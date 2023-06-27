enum Axis { X, Y }

// ignore: constant_identifier_names
enum CallStatus { Connecting, Calling, Ringing, Connected }
enum DataStateType {
  data,
  error,
  idle,
  loading,
}

enum ButtonStateType {
  enabled,
  disabled,
  loading,
}

enum InputType {
  text,
  password,
}

enum ScreenDashboardType {
  dashboard,
  paymentFirstStep,
  paymentSecondStep,
  paymentThreeStep,
  loading,
}

enum ScreenSubscriptionType {
  freeView,
  paymentFirstStep,
  paymentSecondStep,
  paymentThreeStep,
}

enum ScreenTransactionFilterType {
  transactionList,
  parentFilter,
  childFilter,
  timePared,
  type,
}

enum ScreenUpdateInputType {
  updateEmail,
  updatePhone,
}

enum ScreenBusinessType {
  businessDetail,
  paymentFirstStep,
  paymentSecondStep,
  paymentThreeStep,
}

enum ResponseApiType { success, failed, unauthorized }

enum ReceivablesType {
  invoices,
  paid,
  invoicesAndPaid,
}
enum UserType {
  markaaz,
  epsg,
  merchantLynx
}

enum CorrectType {
  correct,
  inCorrect,
  none
}

enum InputTypeController {
  inputBox,
  inputBoxNumber,
  dropDown,
  checkBox,
  photo,
  socialMedia,
  address,
}

enum BeneficialOwner{
  individual,
  business
}


