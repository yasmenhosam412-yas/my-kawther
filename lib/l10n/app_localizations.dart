import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @badResponse.
  ///
  /// In en, this message translates to:
  /// **'Received invalid response from server.'**
  String get badResponse;

  /// No description provided for @requestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request was cancelled.'**
  String get requestCancelled;

  /// No description provided for @unexpectedNetworkError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected network error occurred.'**
  String get unexpectedNetworkError;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Try checking back later or explore other categories.'**
  String get check;

  /// No description provided for @noResent.
  ///
  /// In en, this message translates to:
  /// **'No Recent Search Yet'**
  String get noResent;

  /// No description provided for @cuponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully'**
  String get cuponApplied;

  /// No description provided for @cuponExpired.
  ///
  /// In en, this message translates to:
  /// **'Coupon has expired'**
  String get cuponExpired;

  /// No description provided for @couponRemoved.
  ///
  /// In en, this message translates to:
  /// **'Coupon removed successfully'**
  String get couponRemoved;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Browse products and add them to your cart.'**
  String get cartEmptySubtitle;

  /// No description provided for @startShopping.
  ///
  /// In en, this message translates to:
  /// **'Start Shopping'**
  String get startShopping;

  /// No description provided for @confirmOrder.
  ///
  /// In en, this message translates to:
  /// **'Confirm Order'**
  String get confirmOrder;

  /// No description provided for @noOrder.
  ///
  /// In en, this message translates to:
  /// **'No Orders'**
  String get noOrder;

  /// No description provided for @paymentTool.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentTool;

  /// No description provided for @numberTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer Number'**
  String get numberTransfer;

  /// No description provided for @priceHighToLow.
  ///
  /// In en, this message translates to:
  /// **'Price: High to Low'**
  String get priceHighToLow;

  /// No description provided for @priceLowToHigh.
  ///
  /// In en, this message translates to:
  /// **'Price: Low to High'**
  String get priceLowToHigh;

  /// No description provided for @bestSelling.
  ///
  /// In en, this message translates to:
  /// **'Best Selling'**
  String get bestSelling;

  /// No description provided for @topRated.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// No description provided for @newest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get newest;

  /// No description provided for @uploadImageHerePlease.
  ///
  /// In en, this message translates to:
  /// **'Please upload a photo of your receipt'**
  String get uploadImageHerePlease;

  /// No description provided for @pleaseApplyCouponFirst.
  ///
  /// In en, this message translates to:
  /// **'Please apply your coupon first'**
  String get pleaseApplyCouponFirst;

  /// No description provided for @showless.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showless;

  /// No description provided for @reviewsAndrev.
  ///
  /// In en, this message translates to:
  /// **'Reviews & Ratings'**
  String get reviewsAndrev;

  /// No description provided for @productBorken.
  ///
  /// In en, this message translates to:
  /// **'The product is broken or defective'**
  String get productBorken;

  /// No description provided for @orderIsNowPending.
  ///
  /// In en, this message translates to:
  /// **'Your order is now pending'**
  String get orderIsNowPending;

  /// No description provided for @orderIsNowConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your order has been confirmed'**
  String get orderIsNowConfirmed;

  /// No description provided for @orderDelivered.
  ///
  /// In en, this message translates to:
  /// **'Your order has been delivered'**
  String get orderDelivered;

  /// No description provided for @orderCacelled.
  ///
  /// In en, this message translates to:
  /// **'Your order has been cancelled'**
  String get orderCacelled;

  /// No description provided for @orderRejected.
  ///
  /// In en, this message translates to:
  /// **'Your return request has been rejected'**
  String get orderRejected;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get facebook;

  /// No description provided for @insta.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get insta;

  /// No description provided for @tik.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get tik;

  /// No description provided for @youtube.
  ///
  /// In en, this message translates to:
  /// **'Youtube'**
  String get youtube;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Call'**
  String get phone;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location On Map'**
  String get location;

  /// No description provided for @editMedicne.
  ///
  /// In en, this message translates to:
  /// **'Edit Medicine'**
  String get editMedicne;

  /// No description provided for @medicineEditedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Medicine Edited Successfully'**
  String get medicineEditedSuccessfully;

  /// No description provided for @warinign.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warinign;

  /// No description provided for @onceReminder.
  ///
  /// In en, this message translates to:
  /// **'One-time reminder'**
  String get onceReminder;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get dailyReminder;

  /// No description provided for @specificDaysReminder.
  ///
  /// In en, this message translates to:
  /// **'Specific days'**
  String get specificDaysReminder;

  /// No description provided for @errorEnterMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the medicine name'**
  String get errorEnterMedicineName;

  /// No description provided for @errorAddTime.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one time'**
  String get errorAddTime;

  /// No description provided for @errorSelectOnceDay.
  ///
  /// In en, this message translates to:
  /// **'Please select a day for one-time reminder'**
  String get errorSelectOnceDay;

  /// No description provided for @errorSelectSpecificDays.
  ///
  /// In en, this message translates to:
  /// **'Please select specific days'**
  String get errorSelectSpecificDays;

  /// No description provided for @unnamedMedicine.
  ///
  /// In en, this message translates to:
  /// **'Unnamed medicine'**
  String get unnamedMedicine;

  /// No description provided for @onlyUpdateToday.
  ///
  /// In en, this message translates to:
  /// **'You can update today’s doses only'**
  String get onlyUpdateToday;

  /// No description provided for @deliveryValue.
  ///
  /// In en, this message translates to:
  /// **'Delivery Value'**
  String get deliveryValue;

  /// No description provided for @pleaseSelectGovernorate.
  ///
  /// In en, this message translates to:
  /// **'Please Select Governorate'**
  String get pleaseSelectGovernorate;

  /// No description provided for @feildRequiredalso.
  ///
  /// In en, this message translates to:
  /// **'This field must not be empty'**
  String get feildRequiredalso;

  /// No description provided for @noCities.
  ///
  /// In en, this message translates to:
  /// **'No cities available for delivery'**
  String get noCities;

  /// No description provided for @timeToTakeYourMedicine.
  ///
  /// In en, this message translates to:
  /// **'Time To Take Your Medicine'**
  String get timeToTakeYourMedicine;

  /// No description provided for @stopAlarm.
  ///
  /// In en, this message translates to:
  /// **'Stop Alarm'**
  String get stopAlarm;

  /// No description provided for @sizeNoAvaibleNow.
  ///
  /// In en, this message translates to:
  /// **'This size is not available right now. Please choose a different size!'**
  String get sizeNoAvaibleNow;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @notFoundCat.
  ///
  /// In en, this message translates to:
  /// **'No Categories Found'**
  String get notFoundCat;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please Wait'**
  String get pleaseWait;

  /// No description provided for @noPointsEarned.
  ///
  /// In en, this message translates to:
  /// **'No Points Earned'**
  String get noPointsEarned;

  /// No description provided for @valid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get valid;

  /// No description provided for @notValid.
  ///
  /// In en, this message translates to:
  /// **'Not Valid'**
  String get notValid;

  /// No description provided for @redeemedAt.
  ///
  /// In en, this message translates to:
  /// **'Spent at'**
  String get redeemedAt;

  /// No description provided for @expiredAt.
  ///
  /// In en, this message translates to:
  /// **'Expired At'**
  String get expiredAt;

  /// No description provided for @take.
  ///
  /// In en, this message translates to:
  /// **'Take'**
  String get take;

  /// No description provided for @dose.
  ///
  /// In en, this message translates to:
  /// **'Dose'**
  String get dose;

  /// No description provided for @missedVac.
  ///
  /// In en, this message translates to:
  /// **'Missed Vaccines'**
  String get missedVac;

  /// No description provided for @completedVac.
  ///
  /// In en, this message translates to:
  /// **'Completed Vaccines'**
  String get completedVac;

  /// No description provided for @childred.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get childred;

  /// No description provided for @noChildred.
  ///
  /// In en, this message translates to:
  /// **'No children registered'**
  String get noChildred;

  /// No description provided for @addChild.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChild;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @servicesServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get servicesServices;

  /// No description provided for @medicalTipsServices.
  ///
  /// In en, this message translates to:
  /// **'Medical Tips'**
  String get medicalTipsServices;

  /// No description provided for @ovulationCalculator.
  ///
  /// In en, this message translates to:
  /// **'Ovulation & Menstrual Calculator'**
  String get ovulationCalculator;

  /// No description provided for @pregnancyCalculator.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy & Delivery Calculator'**
  String get pregnancyCalculator;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure Measurement'**
  String get bloodPressure;

  /// No description provided for @bloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Measurement'**
  String get bloodSugar;

  /// No description provided for @bodyWeight.
  ///
  /// In en, this message translates to:
  /// **'Body Weight Calculator'**
  String get bodyWeight;

  /// No description provided for @vaccinationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Schedule'**
  String get vaccinationSchedule;

  /// No description provided for @askPharmacist.
  ///
  /// In en, this message translates to:
  /// **'Ask the Pharmacist'**
  String get askPharmacist;

  /// No description provided for @fertilityCalendar.
  ///
  /// In en, this message translates to:
  /// **'Fertility Calendar'**
  String get fertilityCalendar;

  /// No description provided for @startPeriodCalc.
  ///
  /// In en, this message translates to:
  /// **'Start by calculating your cycle'**
  String get startPeriodCalc;

  /// No description provided for @date2.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date2;

  /// No description provided for @phase.
  ///
  /// In en, this message translates to:
  /// **'Phase'**
  String get phase;

  /// No description provided for @enternewDate.
  ///
  /// In en, this message translates to:
  /// **'Enter New Date'**
  String get enternewDate;

  /// No description provided for @doneSchedule.
  ///
  /// In en, this message translates to:
  /// **'Notifications scheduled successfully'**
  String get doneSchedule;

  /// No description provided for @newPregnaancy.
  ///
  /// In en, this message translates to:
  /// **'New Pregnancy'**
  String get newPregnaancy;

  /// No description provided for @noSavedData.
  ///
  /// In en, this message translates to:
  /// **'No Saved Data'**
  String get noSavedData;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @cm.
  ///
  /// In en, this message translates to:
  /// **'cm'**
  String get cm;

  /// No description provided for @congrats.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!🎉'**
  String get congrats;

  /// No description provided for @youRecieved.
  ///
  /// In en, this message translates to:
  /// **'You Received'**
  String get youRecieved;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @addressOfTake.
  ///
  /// In en, this message translates to:
  /// **'Pick-up Address'**
  String get addressOfTake;

  /// No description provided for @shareProduct.
  ///
  /// In en, this message translates to:
  /// **'Check out this product'**
  String get shareProduct;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @viewHere.
  ///
  /// In en, this message translates to:
  /// **'View it here'**
  String get viewHere;

  /// No description provided for @contactNum.
  ///
  /// In en, this message translates to:
  /// **'Contact number on delivery'**
  String get contactNum;

  /// No description provided for @electricPay.
  ///
  /// In en, this message translates to:
  /// **'Electronic payment'**
  String get electricPay;

  /// No description provided for @areYouSureToDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this child\'s data?'**
  String get areYouSureToDelete;

  /// No description provided for @deletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Child Data Deleted Successfully'**
  String get deletedSuccessfully;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed To Delete Child Data'**
  String get deleteFailed;

  /// No description provided for @pleaseEnterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Phone Number For Contact'**
  String get pleaseEnterPhoneNumber;

  /// No description provided for @cycleLengthMin.
  ///
  /// In en, this message translates to:
  /// **'Cycle Length Must Be At Least 21 Days'**
  String get cycleLengthMin;

  /// No description provided for @periodMin.
  ///
  /// In en, this message translates to:
  /// **'The Period Must Be At Least 3 Day'**
  String get periodMin;

  /// No description provided for @cycleAndPeriodError.
  ///
  /// In en, this message translates to:
  /// **'Please check your period and cycle length values.'**
  String get cycleAndPeriodError;

  /// No description provided for @onDelivery.
  ///
  /// In en, this message translates to:
  /// **'On The Way'**
  String get onDelivery;

  /// No description provided for @readAll.
  ///
  /// In en, this message translates to:
  /// **'Mark All As Read'**
  String get readAll;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @phoneNumberOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone Number ( Optional )'**
  String get phoneNumberOptional;

  /// No description provided for @defultAddress.
  ///
  /// In en, this message translates to:
  /// **'Default Address'**
  String get defultAddress;

  /// No description provided for @contantInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact info'**
  String get contantInfo;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
