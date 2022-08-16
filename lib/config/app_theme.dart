import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme extends ThemeData {
  factory AppTheme.dark() {
    const primary = Color(0xFF7E57C2);
    const accent = Color(0xfffad080); // TODO: this should be secondary

    final base = ThemeData.dark();
    var canvasColor = primary;

    return AppTheme(
        name: 'dark',
        base: base,
        brightness: Brightness.dark,
        colorScheme: base.colorScheme.copyWith(
          primary: accent,
          secondary: base.unselectedWidgetColor,
          surface: canvasColor,
          onSurface: Colors.white,
        ),
        primaryColor: primary,
        accentColor: accent,
        canvasColor: primary,
        backgroundColor: primary,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: primary,
          unselectedItemColor: Colors.black,
        ),
        timePickerTheme: const TimePickerThemeData(
            // backgroundColor : Colors.red,
            //hourMinuteTextColor : Colors.red,
            //hourMinuteColor : Colors.red,
            //dayPeriodTextColor : Colors.red,
            //dayPeriodColor : Colors.red,
            //dialHandColor : Colors.red,
            //dialBackgroundColor : Colors.red,
            //dialTextColor : Colors.red,
            //entryModeIconColor : Colors.red,
            ));
  }

  final welcomePageIndicatorInactive =
      const Color(0xff383a56); // TODO: this should be inside a theme

  final String name;
  final TextStyle welcomePageHeaderSkip;
  final TextStyle welcomePageFooterSkip;
  final TextStyle welcomePageSlogan;
  final TextStyle loginButtonText;
  final TextStyle termsConditionsNotice;
  final TextStyle termsConditionsNoticeBold;

  final TextStyle setupProfileBack;
  final TextStyle setupProfileSkip;
  final TextStyle setupProfileTitle;
  final TextStyle setupProfileSubtitle;
  final TextStyle setupProfileInput;
  final TextStyle setupProfileInputMessage;
  final TextStyle setupProfileInputUnit;
  final TextStyle setupProfileGoalButton;
  final TextStyle setupProfileGoalDescription;
  final TextStyle setupTermsTitle;
  final TextStyle setupProfileLinks;

  final TextStyle menuTitle;
  final TextStyle subMenuTitle;
  final TextStyle menuItem;
  final TextStyle menuSubItem;

  final TextStyle appBarTitle;
  final TextStyle profileDisplayName;
  final TextStyle profileSubtitle;
  final TextStyle profileInviteFriends;
  final TextStyle profileUserDataTitle;
  final TextStyle profileUserDataSubtitle;
  final TextStyle profileUserData;

  final TextStyle subTitle;

  final TextStyle dashboardMotivationTitle;
  final TextStyle dashboardMotivationValue;
  final TextStyle dashboardMotivationLabel;
  final TextStyle dashboardMotivationExplained;
  final TextStyle dashboardMotivationLink;

  final TextStyle dashboardDataTableLabel;
  final TextStyle dashboardDataTableValue;
  final TextStyle dashboardDataGraphSelector;
  final TextStyle dashboardDataGraphPointValue;
  final TextStyle dashboardDataGraphPointDiff;

  final TextStyle dashboardScore;
  final TextStyle dashboardScoreTitle;
  final TextStyle dashboardScoreDiff;
  final TextStyle dashboardScoreSummary;
  final TextStyle dashboardCardTitle;
  final TextStyle dashboardCardSubTitle;
  final TextStyle dashboardCardStatus;
  final TextStyle dashboardCardProgress;
  final TextStyle dashboardMarkerTitle;
  final TextStyle dashboardMarkerSubtitle;
  final TextStyle dashboardMarkerSubtitle2;

  final TextStyle activateScoreDescription;
  final TextStyle activateItemProgress;
  final TextStyle activateItemDescription;

  final TextStyle labResultsGroupTitle;
  final TextStyle labResultsGroupSubTitle;

  final TextStyle chatUserName;
  final TextStyle chatSubTitle;
  final TextStyle chatInfoMessage;
  final TextStyle chatMessage;
  final TextStyle chatTimestamp;

  final TextStyle connectionsHeader;
  final TextStyle connectionsList;
  final TextStyle connectionsText;

  final TextStyle confirmationText;

  final TextStyle panelsHeader;
  final TextStyle panelsTitle;
  final TextStyle panelsGraphLegend;
  final TextStyle panelsGraphTitle;
  final TextStyle panelsGraphSelectedLabel;
  final TextStyle panelsGraphSelectedSubLabel;
  final TextStyle panelsDelete;
  final TextStyle panelsListTitle;
  final TextStyle plansTitle;
  final TextStyle plansTitleChip;
  final TextStyle plansBillingFree;
  final TextStyle plansBillingTitleBold;
  final TextStyle plansBillingTitle;
  final TextStyle plansBillingSubTitleBold;
  final TextStyle plansBillingSubTitle;
  final TextStyle plansFeature;
  final TextStyle plansRenewal;
  final TextStyle plansSaveError;
  final TextStyle paymentAddNewCard;
  final TextStyle paymentChargeNotice;
  final TextStyle sprintAddNewEntry;
  final TextStyle sprintEntryTitle;
  final TextStyle sprintEntryTitleDone;
  final TextStyle sprintEntrySubTitle;
  final TextStyle sprintEntrySummary;
  final TextStyle sprintEntryActions;
  final TextStyle sprintCalendarDate;
  final TextStyle sprintCalendarWeekday;
  final TextStyle sprintConfirmProminent;
  final TextStyle sprintConfirmNormal;
  final TextStyle sprintQuote;
  final TextStyle sprintStart;
  final TextStyle sprintTitleInList;
  final TextStyle userFeedbackChoiceSubtitle;
  final TextStyle coachesButtonText;
  final TextStyle weeklyRecapClose;
  final TextStyle weeklyRecapComment;
  final TextStyle weeklyRecapDate;
  final TextStyle weeklyRecapScore;
  final TextStyle weeklyRecapScoreTitle;
  final TextStyle weeklyRecapScoreDelta;
  final TextStyle multipageTitle;
  final TextStyle multipageTopTitle;
  final TextStyle exercisePage;

  final TextStyle defaultButton;
  final TextStyle addActionOrData;
  final TextStyle weekdayCheckBox;
  final TextStyle sprintBy;
  final TextStyle sprintAuthor;
  final TextStyle sprintBottomDrawer;
  final TextStyle dataCard;
  final TextStyle dataCardHeader;
  final TextStyle labAnalysisDescription;
  final TextStyle reportTitle;
  final TextStyle reportInfo;
  final TextStyle sendReport;

  final TextStyle sprintRecapCardTitle;
  final TextStyle sprintRecapCardSubtitle;
  final TextStyle expiredCardDate;
  final TextStyle expiredCardNumber;
  final TextStyle validCardDate;
  final TextStyle validCardNumber;
  final TextStyle sprintInfo;
  final TextStyle sprintTitleStandalone;

  AppTheme({
    required this.name,
    required ThemeData base,
    required Brightness brightness,
    required Color primaryColor,
    required Color accentColor,
    Color? canvasColor,
    mainAppBarBackgroundColor,
    replayLabelStyle,
    Color? summaryValueColor,
    Color? backgroundColor,
    Color? dividerColor,
    String fontFamily = 'Poppins',
    ColorScheme? colorScheme,
    AppBarTheme? appBarTheme,
    ButtonThemeData? buttonTheme,
    Color? textSelectionColor,
    BottomNavigationBarThemeData? bottomNavigationBarTheme,
    TimePickerThemeData? timePickerTheme,
    bool fixTextFieldOutlineLabel = true,
  })  : welcomePageHeaderSkip = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: const Color(0xffa4a4c4)),
        welcomePageFooterSkip = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        welcomePageSlogan = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),
        loginButtonText =
            GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        termsConditionsNotice = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 10,
            color: const Color(0xff5d5f77)),
        termsConditionsNoticeBold = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 10,
            color: const Color(0xff5d5f77)),
        setupProfileBack = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 16, color: accentColor),
        setupProfileSkip = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: const Color(0xffa4a4c4)),
        setupProfileTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 24, color: Colors.white),
        setupProfileSubtitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        setupProfileInput = GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 30, color: Colors.white),
        setupProfileInputMessage = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 12, color: accentColor),
        setupProfileInputUnit = GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color(0xffa4a4c4)),
        setupProfileGoalButton = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: const Color(0xffa4a4c4)),
        setupProfileGoalDescription = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        setupTermsTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        setupProfileLinks = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 16, color: accentColor),
        menuTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 20, color: Colors.white),
        subMenuTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
        menuItem = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        menuSubItem = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        appBarTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w500, fontSize: 16, color: Colors.white),
        profileDisplayName = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        profileSubtitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        profileInviteFriends = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        subTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 18, color: accentColor),
        profileUserDataTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        profileUserDataSubtitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        profileUserData = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        dashboardMotivationTitle = GoogleFonts.poppins(
          fontWeight: FontWeight.normal,
          fontSize: 10,
          color: const Color(0xffa4a4c4),
        ),
        dashboardMotivationValue = GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 40,
            color: Colors.white,
            height: 1.33),
        dashboardMotivationLabel = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 24, color: accentColor),
        dashboardMotivationExplained = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        dashboardMotivationLink = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xff0d0f26)),
        dashboardDataTableLabel = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 8,
            color: const Color(0xffa4a4c4)),
        dashboardDataTableValue = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        dashboardDataGraphSelector = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 12, color: Colors.white),
        dashboardDataGraphPointValue = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        dashboardDataGraphPointDiff = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 10,
            color: const Color(0xff5d5f77)),
        dashboardScore = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 64, color: Colors.white),
        dashboardScoreTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        dashboardScoreDiff = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 12, color: Colors.white),
        dashboardScoreSummary = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: const Color(0xffa4a4c4)),
        dashboardCardTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 18, color: accentColor),
        dashboardCardSubTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        dashboardCardStatus = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        dashboardCardProgress = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 9, color: Colors.white),
        dashboardMarkerTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
        dashboardMarkerSubtitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
        dashboardMarkerSubtitle2 = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 8,
            color: const Color(0xffa4a4c4)),
        activateScoreDescription = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        activateItemProgress = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        activateItemDescription = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
        labResultsGroupTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white),
        labResultsGroupSubTitle = GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 8,
            color: const Color(0xff5d5f77)),
        chatUserName = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        chatSubTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        chatInfoMessage = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        chatMessage = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xff0d0f26)),
        chatTimestamp = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        connectionsHeader = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 18, color: accentColor),
        connectionsList = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        connectionsText = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        confirmationText = GoogleFonts.poppins(
            fontWeight: FontWeight.normal, fontSize: 14, color: Colors.white),
        panelsHeader = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        panelsTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 18, color: accentColor),
        panelsGraphTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        panelsGraphSelectedLabel = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 12, color: Colors.white),
        panelsGraphSelectedSubLabel = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: const Color(0xff5d5f77)),
        panelsGraphLegend = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: const Color(0xff5d5f77)),
        panelsDelete = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        panelsListTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white),
        plansTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 24, color: accentColor),
        plansTitleChip = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 12, color: primaryColor),
        plansBillingFree = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
        plansBillingTitleBold = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 18, color: primaryColor),
        plansBillingTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 18, color: primaryColor),
        plansBillingSubTitleBold = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 12, color: primaryColor),
        plansBillingSubTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 12, color: primaryColor),
        plansFeature = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        plansRenewal = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 9,
            color: const Color(0xffa4a4c4)),
        paymentAddNewCard = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        paymentChargeNotice = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: const Color(0xffa4a4c4)),
        plansSaveError = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 10, color: Colors.redAccent),
        sprintAddNewEntry = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        sprintEntryTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        sprintEntryTitleDone = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        sprintEntrySubTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        sprintEntrySummary = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        sprintEntryActions = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        sprintCalendarDate = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        sprintCalendarWeekday = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 9, color: Colors.white),
        sprintConfirmProminent = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        sprintConfirmNormal = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        sprintQuote = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4),
            fontStyle: FontStyle.italic),
        sprintStart = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
        sprintTitleInList = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        userFeedbackChoiceSubtitle = GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        coachesButtonText = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 9, color: Colors.white),
        weeklyRecapClose = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        weeklyRecapComment = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        weeklyRecapDate = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: const Color(0xffa4a4c4)),
        weeklyRecapScore = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white),
        multipageTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            fontSize: 30,
            height: 1.33,
            color: accentColor),
        multipageTopTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 12, color: Colors.white),
        exercisePage = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        weeklyRecapScoreTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: const Color(0xffa4a4c4)),
        weeklyRecapScoreDelta = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 12, color: Colors.white),
        weekdayCheckBox = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        defaultButton =
            GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
        addActionOrData = GoogleFonts.poppins(
            color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
        sprintBy = GoogleFonts.poppins(
            color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
        sprintAuthor = GoogleFonts.poppins(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        sprintBottomDrawer = GoogleFonts.poppins(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400),
        dataCard = GoogleFonts.poppins(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        dataCardHeader = GoogleFonts.poppins(
            color: primaryColor, fontSize: 10, fontWeight: FontWeight.w600),
        labAnalysisDescription = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        sprintRecapCardTitle = GoogleFonts.poppins(
            color: Colors.white, fontSize: 56, fontWeight: FontWeight.w300),
        sprintRecapCardSubtitle = GoogleFonts.poppins(
            color: const Color(0xffa4a4c4),
            fontSize: 12,
            fontWeight: FontWeight.w600),
        reportTitle = GoogleFonts.poppins(
            fontWeight: FontWeight.w300, fontSize: 24, color: Colors.white),
        reportInfo = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        sendReport = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
        expiredCardDate = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 10, color: Colors.red),
        expiredCardNumber = GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: const Color(0xff5d5f77)),
        validCardDate = GoogleFonts.poppins(
            fontWeight: FontWeight.w400,
            fontSize: 10,
            color: const Color(0xff5d5f77)),
        validCardNumber = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 14, color: Colors.white),
        sprintInfo = GoogleFonts.poppins(
            fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        sprintTitleStandalone = GoogleFonts.poppins(
            fontWeight: FontWeight.w600, fontSize: 36, color: Colors.white),
        super.raw(
          colorScheme: colorScheme ?? base.colorScheme,
          visualDensity: base.visualDensity,
          primaryColor: primaryColor,
          primaryColorBrightness: base.primaryColorBrightness,
          primaryColorLight: base.primaryColorLight,
          primaryColorDark: base.primaryColorDark,
          accentColor: accentColor,
          accentColorBrightness: base.accentColorBrightness,
          canvasColor: canvasColor ?? backgroundColor!,
          scaffoldBackgroundColor: backgroundColor!,
          bottomAppBarColor: base.bottomAppBarColor,
          cardColor: base.cardColor,
          dividerColor: dividerColor ?? base.dividerColor,
          focusColor: base.focusColor,
          hoverColor: base.hoverColor,
          highlightColor: base.highlightColor,
          splashColor: base.splashColor,
          splashFactory: base.splashFactory,
          selectedRowColor: base.selectedRowColor,
          unselectedWidgetColor: base.unselectedWidgetColor,
          disabledColor: base.disabledColor,
          buttonColor: base.buttonColor,
          toggleButtonsTheme: base.toggleButtonsTheme,
          toggleableActiveColor: base.toggleableActiveColor,
          secondaryHeaderColor: base.secondaryHeaderColor,
          textSelectionColor: textSelectionColor ?? base.textSelectionColor,
          cursorColor: base.cursorColor,
          textSelectionHandleColor:
              textSelectionColor ?? base.textSelectionHandleColor,
          backgroundColor: backgroundColor,
          dialogBackgroundColor: base.dialogBackgroundColor,
          indicatorColor: base.indicatorColor,
          hintColor: base.hintColor,
          errorColor: base.errorColor,
          textTheme: base.textTheme,
          primaryTextTheme: base.primaryTextTheme,
          accentTextTheme: base.accentTextTheme,
          inputDecorationTheme: base.inputDecorationTheme,
          iconTheme: base.iconTheme,
          primaryIconTheme: base.primaryIconTheme,
          accentIconTheme: base.accentIconTheme,
          sliderTheme: base.sliderTheme,
          tabBarTheme: base.tabBarTheme,
          tooltipTheme: base.tooltipTheme,
          cardTheme: base.cardTheme,
          chipTheme: base.chipTheme,
          platform: base.platform,
          materialTapTargetSize: base.materialTapTargetSize,
          applyElevationOverlayColor: base.applyElevationOverlayColor,
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: const CupertinoPageTransitionsBuilder()
          }),
          bottomAppBarTheme: base.bottomAppBarTheme,
          dialogTheme: base.dialogTheme,
          floatingActionButtonTheme: base.floatingActionButtonTheme,
          navigationRailTheme: base.navigationRailTheme,
          typography: base.typography,
          cupertinoOverrideTheme: CupertinoThemeData(primaryColor: accentColor),
          snackBarTheme: base.snackBarTheme,
          bottomSheetTheme: base.bottomSheetTheme,
          popupMenuTheme: base.popupMenuTheme,
          bannerTheme: base.bannerTheme,
          dividerTheme: DividerThemeData(
            indent: 20,
            endIndent: 20,
            thickness: 1,
            color: dividerColor,
          ),
          buttonBarTheme: base.buttonBarTheme,
          buttonTheme: base.buttonTheme.copyWith(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            height: 60,
          ),
          appBarTheme: appBarTheme ??
              AppBarTheme(
                  elevation: 1,
                  color: backgroundColor,
                  textTheme: TextTheme(
                    headline6: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 15,
                      fontStyle: FontStyle.normal,
                      color: base.textTheme.bodyText2?.color,
                    ),
                  ),
                  iconTheme: IconThemeData(color: accentColor),
                  actionsIconTheme:
                      IconThemeData(color: base.textTheme.bodyText2?.color),
                  centerTitle: true),
          bottomNavigationBarTheme: bottomNavigationBarTheme!,
          timePickerTheme: timePickerTheme ?? const TimePickerThemeData(),
          fixTextFieldOutlineLabel: fixTextFieldOutlineLabel,
          elevatedButtonTheme: base.elevatedButtonTheme,
          shadowColor: base.shadowColor,
          textButtonTheme: base.textButtonTheme,
          outlinedButtonTheme: base.outlinedButtonTheme,
          useTextSelectionTheme: true,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Colors.white,
            selectionColor: Color(0xff5d5f77),
            selectionHandleColor: Colors.white,
          ), // TODO: https://github.com/flutter/flutter/issues/43887
          dataTableTheme: base.dataTableTheme,
          checkboxTheme: base.checkboxTheme,
          radioTheme: base.radioTheme,
          scrollbarTheme: base.scrollbarTheme,
          switchTheme: base.switchTheme,
          progressIndicatorTheme: base.progressIndicatorTheme,
          androidOverscrollIndicator: base.androidOverscrollIndicator,
          drawerTheme: base.drawerTheme,
          listTileTheme: base.listTileTheme,
          navigationBarTheme: base.navigationBarTheme,
          useMaterial3: base.useMaterial3,
          expansionTileTheme: const ExpansionTileThemeData(),
          extensions: {},
        );

  static AppTheme of(BuildContext context) {
    // TODO: when other themes are implemented return active theme
    return AppTheme.dark();
  }

  Theme withTheme(child) => Theme(
      data: copyWith(
          cursorColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide:
                    const BorderSide(color: Color(0xffa4a4c4), width: 1.25)),
          )),
      child: child);

  flatButton({primary, height, width, padding}) {
    return TextButton.styleFrom(
        primary: Colors.white,
        minimumSize: Size(width ?? 80, height ?? 40),
        padding: padding ?? EdgeInsets.zero);
  }
}
