import 'dart:convert' show base64;
import 'dart:typed_data' show Uint8List, ByteData;

import 'utils.dart';

/// A very fast and memory efficient class to encode and decode to and from BASE64 in full accordance
/// with RFC 2045.<br>
/// <br>
/// On Windows XP sp1 with 1.4.2_04 and later ;), this encoder and decoder is about 10 times faster
/// on small arrays (10 - 1000 bytes) and 2-3 times as fast on larger arrays (10000 - 1000000 bytes)
/// compared to <code>sun.misc.Encoder()/Decoder()</code>.<br>
/// <br>
///
/// On byte arrays the encoder is about 20% faster than Jakarta Commons Base64 Codec for encode and
/// about 50% faster for decoding large arrays. This implementation is about twice as fast on very small
/// arrays (&lt 30 bytes). If source/destination is a <code>String</code> this
/// version is about three times as fast due to the fact that the Commons Codec result has to be recoded
/// to a <code>String</code> from <code>List<int></code>, which is very expensive.<br>
/// <br>
///
/// This encode/decode algorithm doesn't create any temporary arrays as many other codecs do, it only
/// allocates the resulting array. This produces less garbage and it is possible to handle arrays twice
/// as large as algorithms that create a temporary array. (E.g. Jakarta Commons Codec). It is unknown
/// whether Sun's <code>sun.misc.Encoder()/Decoder()</code> produce temporary arrays but since performance
/// is quite low it probably does.<br>
/// <br>
///
/// The encoder produces the same output as the Sun one except that the Sun's encoder appends
/// a trailing line separator if the last character isn't a pad. Unclear why but it only adds to the
/// length and is probably a side effect. Both are in conformance with RFC 2045 though.<br>
/// Commons codec seem to always att a trailing line separator.<br>
/// <br>
///
/// <b>Note!</b>
/// The encode/decode method pairs (types) come in three versions with the <b>exact</b> same algorithm and
/// thus a lot of code redundancy. This is to not create any temporary arrays for transcoding to/from different
/// format types. The methods not used can simply be commented out.<br>
/// <br>
///
/// There is also a "fast" version of all decode methods that works the same way as the normal ones, but
/// har a few demands on the decoded input. Normally though, these fast verions should be used if the source if
/// the input is known and it hasn't bee tampered with.<br>
/// <br>
///
/// If you find the code useful or you find a bug, please send me a note at base64 @ miginfocom . com.
///
/// @version 2.2
/// @author Mikael Grev
///         Date: 2004-aug-02
///         Time: 11:31:11

class Base64 {
  static const String ca =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
  static final List<int> ia = initIA();
  static final int eq = '='.runes.first;

  const Base64._();

  // ****************************************************************************************
  // * char[] version
  // ****************************************************************************************
  /// Encodes a raw byte array into a BASE64 <code>char[]</code> representation i accordance with RFC 2045.
  ///
  /// @param sArr The bytes to convert. If <code>null</code> or length 0 an empty array will be returned.
  /// @param lineSep Optional "\r\n" after 76 characters, unless end of file.<br>
  ///        No line separator will be in breach of RFC 2045 which specifies max 76 per line but will be a
  ///        little faster.
  /// @return A BASE64 encoded array. Never <code>null</code>.
  static List<int> encodeToChar(List<int> sArr, bool lineSep) {
    if (sArr.isEmpty) {
      return [];
    }

    Uint8List outputList = Uint8List.fromList(sArr);
    String outputStr = base64.encode(outputList);
    int length = outputStr.length;

    if (!lineSep || length < 76) {
      return base64.decode(outputStr);
    }

    int startIndex = 0;
    int endIndex = 76;

    StringBuffer buffer = StringBuffer();
    List<int> out = List.empty(growable: true);

    while (startIndex < length) {
      String str = outputStr.substring(startIndex, endIndex);
      buffer.write(str);
      out.addAll(base64.decode(buffer.toString()));

      startIndex = endIndex;
      if (endIndex + 76 > length) {
        endIndex = length;
      } else {
        endIndex += 76;
      }
      buffer.clear();
    }

    return out;
  }

  // ****************************************************************************************
  // * List<int> version
  // ****************************************************************************************
  static String? decodeToString(List<int>? content) {
    return Utils.isBlank(content) ? null : Utils.toUtf8(decode_(content!)!);
  }

  /// Decodes a BASE64 encoded byte array. All illegal characters will be ignored and can handle both arrays with
  /// and without line separators.
  ///
  /// @param sArr The source array. Length 0 will return an empty array. <code>null</code> will throw an exception.
  /// @return The decoded array of bytes. May be of length 0. Will be <code>null</code> if the legal characters
  ///         (including '=') isn't divideable by 4. (I.e. definitely corrupted).
  static List<int>? decode_(List<int> sArr) {
    // Check special case
    int sLen = sArr.length;

    // Count illegal characters (including '\r', '\n') to know what size the returned array will be,
    // so we don't have to reallocate & copy it later.
    int sepCnt =
        0; // Number of separator characters. (Actually illegal characters, but that's a bonus...)
    for (int i = 0; i < sLen; i++) {
      if (ia[sArr[i] & 0xff] < 0) {
        sepCnt++;
      }
    }

    // Check so that legal chars (including '=') are evenly divideable by 4 as specified in RFC 2045.
    if ((sLen - sepCnt) % 4 != 0) {
      return null;
    }

    int pad = 0;
    for (int i = sLen; i > 1 && ia[sArr[--i] & 0xff] <= 0;) {
      if (sArr[i] == eq) {
        pad++;
      }
    }

    int len = ((sLen - sepCnt) * 6 >> 3) - pad;

    List<int> dArr = List.filled(len, -1, growable: false);

    for (int s = 0, d = 0; d < len;) {
      // Assemble three bytes into an int from four "valid" characters.
      int i = 0;
      for (int j = 0; j < 4; j++) {
        // j only increased if a valid char was found.
        int c = ia[sArr[s++] & 0xff];
        if (c >= 0) {
          i |= c << 18 - j * 6;
        } else {
          j--;
        }
      }

      // Add the bytes
      ByteData bdata = ByteData(8);
      bdata.setUint8(0, i >> 16);
      dArr[d++] = bdata.getUint8(0);

      if (d < len) {
        ByteData bdata = ByteData(8);
        bdata.setUint8(0, i >> 8);
        dArr[d++] = bdata.getUint8(0);

        if (d < len) {
          ByteData bdata = ByteData(8);
          bdata.setUint8(0, i);
          dArr[d++] = bdata.getUint8(0);
        }
      }
    }

    return dArr;
  }

  // ****************************************************************************************
  // * String version
  // ****************************************************************************************

  static String? encode(String? str) {
    return Utils.isBlank(str) ? null : encode_(str!.codeUnits);
  }

  static String encode_(List<int> sArr) {
    return encode__(sArr, false);
  }

  /// Encodes a raw byte array into a BASE64 <code>String</code> representation i accordance with RFC 2045.
  ///
  /// @param sArr The bytes to convert. If <code>null</code> or length 0 an empty array will be returned.
  /// @param lineSep Optional "\r\n" after 76 characters, unless end of file.<br>
  ///        No line separator will be in breach of RFC 2045 which specifies max 76 per line but will be a
  ///        little faster.
  /// @return A BASE64 encoded array. Never <code>null</code>.
  // ignore: non_constant_identifier_names
  static String encode__(List<int> sArr, bool lineSep) {
    // Reuse char[] since we can't create a String incrementally anyway
    // and StringBuffer/Builder would be slower.
    return base64.encode(encodeToChar(sArr, lineSep));
  }

  /// Decodes a BASE64 encoded <code>String</code>. All illegal characters will be ignored and can handle both strings
  /// with
  /// and without line separators.<br>
  /// <b>Note!</b> It can be up to about 2x the speed to call <code>decode(str.toCharArray())</code> instead. That
  /// will create a temporary array though. This version will use <code>str.charAt(i)</code> to iterate the string.
  ///
  /// @param str The source string. <code>null</code> or length 0 will return an empty array.
  /// @return The decoded array of bytes. May be of length 0. Will be <code>null</code> if the legal characters
  ///         (including '=') isn't divideable by 4. (I.e. definitely corrupted).
  static List<int>? decode(String? str) {
    str = str?.replaceAll("data:image.*base64,", "");

    // Check special case
    int sLen = str != null ? str.length : 0;
    if (sLen == 0) {
      return [];
    }

    // Count illegal characters (including '\r', '\n') to know what size the returned
    // array will be, so we don't have to reallocate & copy it later.
    int sepCnt =
        0; // Number of separator characters. (Actually illegal characters, but that's a bonus...)
    for (int i = 0; i < sLen; i++) {
      if (ia[str!.codeUnitAt(i)] < 0) {
        sepCnt++;
      }
    }

    // Check so that legal chars (including '=') are evenly divideable by 4 as specified in RFC 2045.
    if ((sLen - sepCnt) % 4 != 0) {
      return null;
    }

    // Count '=' at end
    int pad = 0;
    for (int i = sLen; i > 1 && ia[str!.codeUnitAt(--i)] <= 0;) {
      if (str[i] == '=') {
        pad++;
      }
    }

    int len = ((sLen - sepCnt) * 6 >> 3) - pad;
    Uint8List dArr = Uint8List(len);

    for (int s = 0, d = 0; d < len;) {
      // Assemble three bytes into an int from four "valid" characters.
      int i = 0;
      for (int j = 0; j < 4; j++) {
        // j only increased if a valid char was found.
        int c = ia[str!.codeUnitAt(s++)];
        if (c >= 0) {
          i |= c << 18 - j * 6;
        } else {
          j--;
        }
      }

      // Add the bytes
      dArr[d++] = (i >> 16);
      if (d < len) {
        dArr[d++] = (i >> 8);
        if (d < len) {
          ByteData bdata = ByteData(1);
          bdata.setUint8(0, i);
          dArr[d++] = bdata.getUint8(0);
        }
      }
    }

    return dArr;
  }

  static getLineEnd(List<String> strList) {
    return strList.map((e) => int.parse(e)).toList(growable: false);
  }

  static List<int> initIA() {
    List<int> ia = List.filled(256, -1, growable: false);

    for (int i = 0, iS = ca.length; i < iS; i++) {
      ia[ca.codeUnitAt(i)] = i;
    }
    ia[eq] = 0;
    return ia;
  }
}
