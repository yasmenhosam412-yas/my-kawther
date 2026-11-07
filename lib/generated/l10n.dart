// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes
// ignore_for_file: constant_identifier_names

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  String get AddNotes => Intl.message(
    'Add notes',
    name: 'AddNotes',
    desc: '',
    args: [],
  );

  String get ChanceOfPregnancy => Intl.message(
    'Chance Of Pregnancy',
    name: 'ChanceOfPregnancy',
    desc: '',
    args: [],
  );

  String get ConfirmNewPass => Intl.message(
    'Confirm New Password',
    name: 'ConfirmNewPass',
    desc: '',
    args: [],
  );

  String get DurationCycles => Intl.message(
    'Duration between cycles',
    name: 'DurationCycles',
    desc: '',
    args: [],
  );

  String get EmailAlreadyExist => Intl.message(
    'Email Already Exists',
    name: 'EmailAlreadyExist',
    desc: '',
    args: [],
  );

  String get PhoneAlreadyExists => Intl.message(
    'Phone Number Already Exists',
    name: 'PhoneAlreadyExists',
    desc: '',
    args: [],
  );

  String get aNewMedicineHasBeenSuccessfullyAdded => Intl.message(
    'A new medicine has been successfully added',
    name: 'aNewMedicineHasBeenSuccessfullyAdded',
    desc: '',
    args: [],
  );

  String get about_Pateient_app => Intl.message(
    'About Pateient App',
    name: 'about_Pateient_app',
    desc: '',
    args: [],
  );

  String get accepted => Intl.message(
    'Accepted',
    name: 'accepted',
    desc: '',
    args: [],
  );

  String get account => Intl.message(
    'Account',
    name: 'account',
    desc: '',
    args: [],
  );

  String get accountCreatedSuccessfully => Intl.message(
    'Account created successfully',
    name: 'accountCreatedSuccessfully',
    desc: '',
    args: [],
  );

  String get account_details => Intl.message(
    'Review your account details and order updates here',
    name: 'account_details',
    desc: '',
    args: [],
  );

  String get achieved => Intl.message(
    'Achieved',
    name: 'achieved',
    desc: '',
    args: [],
  );

  String get active => Intl.message(
    'Active',
    name: 'active',
    desc: '',
    args: [],
  );

  String get add => Intl.message(
    'Add',
    name: 'add',
    desc: '',
    args: [],
  );

  String get addChild => Intl.message(
    'Add Child',
    name: 'addChild',
    desc: '',
    args: [],
  );

  String get addContraceptiveMedication => Intl.message(
    'Add Contraceptive Medication',
    name: 'addContraceptiveMedication',
    desc: '',
    args: [],
  );

  String get addImage => Intl.message(
    'Add Image',
    name: 'addImage',
    desc: '',
    args: [],
  );

  String get addMedication => Intl.message(
    'Add Medication',
    name: 'addMedication',
    desc: '',
    args: [],
  );

  String get addNewAddress => Intl.message(
    'Add New Address',
    name: 'addNewAddress',
    desc: '',
    args: [],
  );

  String get addNewAddressButton => Intl.message(
    'Add New Address',
    name: 'addNewAddressButton',
    desc: '',
    args: [],
  );

  String get addNewMedicine => Intl.message(
    'Add new medicine',
    name: 'addNewMedicine',
    desc: '',
    args: [],
  );

  String get addNewTime => Intl.message(
    '+ Add new time',
    name: 'addNewTime',
    desc: '',
    args: [],
  );

  String get addPhoto => Intl.message(
    'Add photo',
    name: 'addPhoto',
    desc: '',
    args: [],
  );

  String get addProfessionalCard => Intl.message(
    'Add your professional card',
    name: 'addProfessionalCard',
    desc: '',
    args: [],
  );

  String get addProfessionalCardAndPhoto => Intl.message(
    'Add your professional card and personal photo',
    name: 'addProfessionalCardAndPhoto',
    desc: '',
    args: [],
  );

  String get addToCart => Intl.message(
    'Add to Cart',
    name: 'addToCart',
    desc: '',
    args: [],
  );

  String get add_address => Intl.message(
    'Add Address',
    name: 'add_address',
    desc: '',
    args: [],
  );

  String get add_medicine_and_reminder => Intl.message(
    'Please add medications and set reminders',
    name: 'add_medicine_and_reminder',
    desc: '',
    args: [],
  );

  String get add_new_address => Intl.message(
    'Add New Address',
    name: 'add_new_address',
    desc: '',
    args: [],
  );

  String get add_new_card => Intl.message(
    'Add New Card',
    name: 'add_new_card',
    desc: '',
    args: [],
  );

  String get add_new_time => Intl.message(
    'Add A New Time',
    name: 'add_new_time',
    desc: '',
    args: [],
  );

  String get add_notes => Intl.message(
    'Add notes',
    name: 'add_notes',
    desc: '',
    args: [],
  );

  String get add_payment_method => Intl.message(
    'Add Payment Method',
    name: 'add_payment_method',
    desc: '',
    args: [],
  );

  String get add_photo => Intl.message(
    'Add Photo',
    name: 'add_photo',
    desc: '',
    args: [],
  );

  String get add_reminder => Intl.message(
    'Add Reminder',
    name: 'add_reminder',
    desc: '',
    args: [],
  );

  String get add_your_profile_picture => Intl.message(
    'Add your profile picture',
    name: 'add_your_profile_picture',
    desc: '',
    args: [],
  );

  String get addaAeminderForBirthControlMedication => Intl.message(
    'Add a reminder for birth control medication',
    name: 'addaAeminderForBirthControlMedication',
    desc: '',
    args: [],
  );

  String get addaReminder => Intl.message(
    'Add a reminder',
    name: 'addaReminder',
    desc: '',
    args: [],
  );

  String get addedToCart => Intl.message(
    'A item has been added to cart',
    name: 'addedToCart',
    desc: '',
    args: [],
  );

  String get addedToFavorites => Intl.message(
    'A item has been added to favorites',
    name: 'addedToFavorites',
    desc: '',
    args: [],
  );

  String get address => Intl.message(
    'Address',
    name: 'address',
    desc: '',
    args: [],
  );

  String get addressAddedSuccess => Intl.message(
    'Address added successfully!',
    name: 'addressAddedSuccess',
    desc: '',
    args: [],
  );

  String get addressDetails => Intl.message(
    'Address Details',
    name: 'addressDetails',
    desc: '',
    args: [],
  );

  String get addressOfTake => Intl.message(
    'Pick-up Address',
    name: 'addressOfTake',
    desc: '',
    args: [],
  );

  String get addressType => Intl.message(
    'Address Type',
    name: 'addressType',
    desc: '',
    args: [],
  );

  String get addressUpdatedSuccess => Intl.message(
    'Address updated successfully!',
    name: 'addressUpdatedSuccess',
    desc: '',
    args: [],
  );

  String get address_added_success => Intl.message(
    'Your new address has been added successfully',
    name: 'address_added_success',
    desc: '',
    args: [],
  );

  String get address_edited_success => Intl.message(
    'Your address has been edited successfully',
    name: 'address_edited_success',
    desc: '',
    args: [],
  );

  String get address_type => Intl.message(
    'Address Type',
    name: 'address_type',
    desc: '',
    args: [],
  );

  String get addressesTitle => Intl.message(
    'Addresses',
    name: 'addressesTitle',
    desc: '',
    args: [],
  );

  String get after => Intl.message(
    'After',
    name: 'after',
    desc: '',
    args: [],
  );

  String get afterBreakFast => Intl.message(
    'After BreakFast',
    name: 'afterBreakFast',
    desc: '',
    args: [],
  );

  String get afterDinner => Intl.message(
    'After Dinner',
    name: 'afterDinner',
    desc: '',
    args: [],
  );

  String get afterEating => Intl.message(
    'After Eating',
    name: 'afterEating',
    desc: '',
    args: [],
  );

  String get afterLunch => Intl.message(
    'After Lunch',
    name: 'afterLunch',
    desc: '',
    args: [],
  );

  String get afterMeal => Intl.message(
    '2 Hours After Meal',
    name: 'afterMeal',
    desc: '',
    args: [],
  );

  String get ahmedMaherPharmacy => Intl.message(
    'Ahmed Maher Pharmacy',
    name: 'ahmedMaherPharmacy',
    desc: '',
    args: [],
  );

  String get ahmedMaherPharmacyAddress => Intl.message(
    '123 Tahrir Street, Mohandessin, Cairo',
    name: 'ahmedMaherPharmacyAddress',
    desc: '',
    args: [],
  );

  String get ahmed_ibrahim => Intl.message(
    'Ahmed Ibrahim',
    name: 'ahmed_ibrahim',
    desc: '',
    args: [],
  );

  String get alert => Intl.message(
    'Alert',
    name: 'alert',
    desc: '',
    args: [],
  );

  String get all_products => Intl.message(
    'All Products',
    name: 'all_products',
    desc: '',
    args: [],
  );

  String get alreadyExist => Intl.message(
    'Already applied for refund request!',
    name: 'alreadyExist',
    desc: '',
    args: [],
  );

  String get alreadyHaveAccount => Intl.message(
    'Already have an account?',
    name: 'alreadyHaveAccount',
    desc: '',
    args: [],
  );

  String get amountOfPoints => Intl.message(
    '80 Point Expires in 3 Feb , 2025',
    name: 'amountOfPoints',
    desc: '',
    args: [],
  );

  String get apartmentNumber => Intl.message(
    'Apartment Number',
    name: 'apartmentNumber',
    desc: '',
    args: [],
  );

  String get apartment_number => Intl.message(
    'Apartment Number',
    name: 'apartment_number',
    desc: '',
    args: [],
  );

  String get appTitle => Intl.message(
    'My App',
    name: 'appTitle',
    desc: '',
    args: [],
  );

  String get apply => Intl.message(
    'Apply',
    name: 'apply',
    desc: '',
    args: [],
  );

  String get approved => Intl.message(
    'Approved',
    name: 'approved',
    desc: '',
    args: [],
  );

  String get arabic => Intl.message(
    'Arabic',
    name: 'arabic',
    desc: '',
    args: [],
  );

  String get are_you_sure => Intl.message(
    'Are you sure you want to cancel the order?',
    name: 'are_you_sure',
    desc: '',
    args: [],
  );

  String get are_you_sure_to_delete => Intl.message(
    'Are you sure you want to delete this child\'s data?',
    name: 'are_you_sure_to_delete',
    desc: '',
    args: [],
  );

  String get arrangement => Intl.message(
    'Arrangement',
    name: 'arrangement',
    desc: '',
    args: [],
  );

  String get askDoctor => Intl.message(
    'Ask Doctor',
    name: 'askDoctor',
    desc: '',
    args: [],
  );

  String get ask_pharmacist => Intl.message(
    'Ask the Pharmacist',
    name: 'ask_pharmacist',
    desc: '',
    args: [],
  );

  String get auto_reply => Intl.message(
    'Auto Reply',
    name: 'auto_reply',
    desc: '',
    args: [],
  );

  String get availableAgain => Intl.message(
    'Available Again',
    name: 'availableAgain',
    desc: '',
    args: [],
  );

  String get babyName => Intl.message(
    'Baby Name',
    name: 'babyName',
    desc: '',
    args: [],
  );

  String get babyNameEnter => Intl.message(
    'Enter Baby Name',
    name: 'babyNameEnter',
    desc: '',
    args: [],
  );

  String get back_to_home => Intl.message(
    'Back to Home',
    name: 'back_to_home',
    desc: '',
    args: [],
  );

  String get badRequest => Intl.message(
    'Bad request. Please check your input.',
    name: 'badRequest',
    desc: '',
    args: [],
  );

  String get badResponse => Intl.message(
    'Received invalid response from server.',
    name: 'badResponse',
    desc: '',
    args: [],
  );

  String get beautyConsultation => Intl.message(
    'Beauty Consultation',
    name: 'beautyConsultation',
    desc: '',
    args: [],
  );

  String get beauty_consultation => Intl.message(
    'Beauty Consultation',
    name: 'beauty_consultation',
    desc: '',
    args: [],
  );

  String get before => Intl.message(
    'Before',
    name: 'before',
    desc: '',
    args: [],
  );

  String get beforeBreakFast => Intl.message(
    'Before BreakFast',
    name: 'beforeBreakFast',
    desc: '',
    args: [],
  );

  String get beforeDinner => Intl.message(
    'Before Dinner',
    name: 'beforeDinner',
    desc: '',
    args: [],
  );

  String get beforeEating => Intl.message(
    'Before Eating',
    name: 'beforeEating',
    desc: '',
    args: [],
  );

  String get beforeLunch => Intl.message(
    'Before Lunch',
    name: 'beforeLunch',
    desc: '',
    args: [],
  );

  String get bestSellingProducts => Intl.message(
    'Best Selling Products',
    name: 'bestSellingProducts',
    desc: '',
    args: [],
  );

  String get best_selling => Intl.message(
    'Best Selling',
    name: 'best_selling',
    desc: '',
    args: [],
  );

  String get bigDiscounts => Intl.message(
    'Big Discounts 🔥',
    name: 'bigDiscounts',
    desc: '',
    args: [],
  );

  String get blood_pressure => Intl.message(
    'Blood Pressure Measurement',
    name: 'blood_pressure',
    desc: '',
    args: [],
  );

  String get blood_sugar => Intl.message(
    'Blood Sugar Measurement',
    name: 'blood_sugar',
    desc: '',
    args: [],
  );

  String get bodyIndexScore => Intl.message(
    'Your Body Index Score',
    name: 'bodyIndexScore',
    desc: '',
    args: [],
  );

  String get bodyWeightCalculator => Intl.message(
    'Body Weight Calculator',
    name: 'bodyWeightCalculator',
    desc: '',
    args: [],
  );

  String get body_weight => Intl.message(
    'Body Weight Calculator',
    name: 'body_weight',
    desc: '',
    args: [],
  );

  String get brands => Intl.message(
    'Brands',
    name: 'brands',
    desc: '',
    args: [],
  );

  String get browseMedicinesSupplements => Intl.message(
    'Browse medicines, alternatives, and supplements with detailed information.',
    name: 'browseMedicinesSupplements',
    desc: '',
    args: [],
  );

  String get buildingNumber => Intl.message(
    'Building Number',
    name: 'buildingNumber',
    desc: '',
    args: [],
  );

  String get building_number => Intl.message(
    'Building Number',
    name: 'building_number',
    desc: '',
    args: [],
  );

  String get calc => Intl.message(
    'Calculate',
    name: 'calc',
    desc: '',
    args: [],
  );

  String get calendar => Intl.message(
    'Calendar',
    name: 'calendar',
    desc: '',
    args: [],
  );

  String get cancel => Intl.message(
    'Cancel',
    name: 'cancel',
    desc: '',
    args: [],
  );

  String get cancel_order => Intl.message(
    'cancel Order',
    name: 'cancel_order',
    desc: '',
    args: [],
  );

  String get canceled => Intl.message(
    'Canceled',
    name: 'canceled',
    desc: '',
    args: [],
  );

  String get cancellation_policy => Intl.message(
    'cancellation Policy',
    name: 'cancellation_policy',
    desc: '',
    args: [],
  );

  String get cancelled => Intl.message(
    'Cancelled',
    name: 'cancelled',
    desc: '',
    args: [],
  );

  String get card_added_success => Intl.message(
    'Your new card has been added successfully',
    name: 'card_added_success',
    desc: '',
    args: [],
  );

  String get card_number => Intl.message(
    'Card Number',
    name: 'card_number',
    desc: '',
    args: [],
  );

  String get cardholder_name => Intl.message(
    'Cardholder Name',
    name: 'cardholder_name',
    desc: '',
    args: [],
  );

  String get cart => Intl.message(
    'Cart',
    name: 'cart',
    desc: '',
    args: [],
  );

  String get cartEmpty => Intl.message(
    'Your cart is empty',
    name: 'cartEmpty',
    desc: '',
    args: [],
  );

  String get cartEmptySubtitle => Intl.message(
    'Your cart is empty. Browse products and add them to your cart.',
    name: 'cartEmptySubtitle',
    desc: '',
    args: [],
  );

  String get case_details => Intl.message(
    'Case Details',
    name: 'case_details',
    desc: '',
    args: [],
  );

  String get case_name => Intl.message(
    'Case',
    name: 'case_name',
    desc: '',
    args: [],
  );

  String get cases => Intl.message(
    'Cases',
    name: 'cases',
    desc: '',
    args: [],
  );

  String get cash => Intl.message(
    'Cash',
    name: 'cash',
    desc: '',
    args: [],
  );

  String get cashOn => Intl.message(
    'Cash on Delivery',
    name: 'cashOn',
    desc: '',
    args: [],
  );

  String get categories => Intl.message(
    'Categories',
    name: 'categories',
    desc: '',
    args: [],
  );

  String get change => Intl.message(
    'Change',
    name: 'change',
    desc: '',
    args: [],
  );

  String get changeLanguage => Intl.message(
    'Change Language',
    name: 'changeLanguage',
    desc: '',
    args: [],
  );

  String get change_of_mind => Intl.message(
    'Change of mind',
    name: 'change_of_mind',
    desc: '',
    args: [],
  );

  String get check => Intl.message(
    'Try checking back later or explore other categories.',
    name: 'check',
    desc: '',
    args: [],
  );

  String get checkout => Intl.message(
    'Checkout',
    name: 'checkout',
    desc: '',
    args: [],
  );

  String get childred => Intl.message(
    'Children',
    name: 'childred',
    desc: '',
    args: [],
  );

  String get chooseStrongPassword => Intl.message(
    'Choose a secure password to ensure the protection of your personal account',
    name: 'chooseStrongPassword',
    desc: '',
    args: [],
  );

  String get civil => Intl.message(
    'Civil',
    name: 'civil',
    desc: '',
    args: [],
  );

  String get clearAll => Intl.message(
    'Clear All',
    name: 'clearAll',
    desc: '',
    args: [],
  );

  String get clickToUpload => Intl.message(
    'Click to upload',
    name: 'clickToUpload',
    desc: '',
    args: [],
  );

  String get clickToView => Intl.message(
    'Click to view',
    name: 'clickToView',
    desc: '',
    args: [],
  );

  String get click_to_view => Intl.message(
    'Click to view',
    name: 'click_to_view',
    desc: '',
    args: [],
  );

  String get client_name => Intl.message(
    'Client Name',
    name: 'client_name',
    desc: '',
    args: [],
  );

  String get cm => Intl.message(
    'cm',
    name: 'cm',
    desc: '',
    args: [],
  );

  String get coming => Intl.message(
    'Coming',
    name: 'coming',
    desc: '',
    args: [],
  );

  String get comingVac => Intl.message(
    'Coming Vaccines',
    name: 'comingVac',
    desc: '',
    args: [],
  );

  String get comment => Intl.message(
    'Comment',
    name: 'comment',
    desc: '',
    args: [],
  );

  String get company => Intl.message(
    'Company',
    name: 'company',
    desc: '',
    args: [],
  );

  String get complete => Intl.message(
    'Complete',
    name: 'complete',
    desc: '',
    args: [],
  );

  String get complete_purchase => Intl.message(
    'Complete Purchase',
    name: 'complete_purchase',
    desc: '',
    args: [],
  );

  String get completed => Intl.message(
    'Completed',
    name: 'completed',
    desc: '',
    args: [],
  );

  String get completedVac => Intl.message(
    'Completed Vaccines',
    name: 'completedVac',
    desc: '',
    args: [],
  );

  String get completed_order => Intl.message(
    'Completed',
    name: 'completed_order',
    desc: '',
    args: [],
  );

  String get confirm => Intl.message(
    'Confirm',
    name: 'confirm',
    desc: '',
    args: [],
  );

  String get confirmDelete => Intl.message(
    'Are you sure you want to delete?',
    name: 'confirmDelete',
    desc: '',
    args: [],
  );

  String get confirmNewPasswordHere => Intl.message(
    'Confirm new password here',
    name: 'confirmNewPasswordHere',
    desc: '',
    args: [],
  );

  String get confirmOrder => Intl.message(
    'Confirm Order',
    name: 'confirmOrder',
    desc: '',
    args: [],
  );

  String get confirmPassword => Intl.message(
    'Confirm Password',
    name: 'confirmPassword',
    desc: '',
    args: [],
  );

  String get confirm_delete_account => Intl.message(
    'Are you sure you want to delete your account?',
    name: 'confirm_delete_account',
    desc: '',
    args: [],
  );

  String get confirm_sign_out => Intl.message(
    'Do you want to sign out of the app?',
    name: 'confirm_sign_out',
    desc: '',
    args: [],
  );

  String get conflict => Intl.message(
    ' The item is already added',
    name: 'conflict',
    desc: '',
    args: [],
  );

  String get congrats => Intl.message(
    'Congratulations!🎉',
    name: 'congrats',
    desc: '',
    args: [],
  );

  String get connectionTimeout => Intl.message(
    'Connection timed out. Please try again.',
    name: 'connectionTimeout',
    desc: '',
    args: [],
  );

  String get contactNum => Intl.message(
    'Contact number on delivery',
    name: 'contactNum',
    desc: '',
    args: [],
  );

  String get contactUs => Intl.message(
    'Contact Us',
    name: 'contactUs',
    desc: '',
    args: [],
  );

  String get contact_us => Intl.message(
    'Contact Us',
    name: 'contact_us',
    desc: '',
    args: [],
  );

  String get contantInfo => Intl.message(
    'Contact info',
    name: 'contantInfo',
    desc: '',
    args: [],
  );

  String get continueAsVisitor => Intl.message(
    'Continue as Visitor',
    name: 'continueAsVisitor',
    desc: '',
    args: [],
  );

  String get continue_shopping => Intl.message(
    'Continue shopping',
    name: 'continue_shopping',
    desc: '',
    args: [],
  );

  String get continuousHealthSupport => Intl.message(
    'Continuous health support',
    name: 'continuousHealthSupport',
    desc: '',
    args: [],
  );

  String get count => Intl.message(
    'Count',
    name: 'count',
    desc: '',
    args: [],
  );

  String get couponRemoved => Intl.message(
    'Coupon removed successfully',
    name: 'couponRemoved',
    desc: '',
    args: [],
  );

  String get createAccount => Intl.message(
    'Create Account',
    name: 'createAccount',
    desc: '',
    args: [],
  );

  String get createAccountNowAndEnjoyExclusiveFeatures => Intl.message(
    'createAccountNowAndEnjoyExclusiveFeatures',
    name: 'createAccountNowAndEnjoyExclusiveFeatures',
    desc: '',
    args: [],
  );

  String get createAccountOrLogin => Intl.message(
    'Create Account or Login',
    name: 'createAccountOrLogin',
    desc: '',
    args: [],
  );

  String get createLawyerAccount => Intl.message(
    'Create Lawyer Account',
    name: 'createLawyerAccount',
    desc: '',
    args: [],
  );

  String get createLawyerAccountDiscreption => Intl.message(
    'enter your Name, Phone and Email',
    name: 'createLawyerAccountDiscreption',
    desc: '',
    args: [],
  );

  String get createNewPassword => Intl.message(
    'Create new password',
    name: 'createNewPassword',
    desc: '',
    args: [],
  );

  String get createNewPasswordDescription => Intl.message(
    'Create a password to secure your account.',
    name: 'createNewPasswordDescription',
    desc: '',
    args: [],
  );

  String get create_account_or_sign_in => Intl.message(
    'Create Account or Sign In',
    name: 'create_account_or_sign_in',
    desc: '',
    args: [],
  );

  String get credit_card => Intl.message(
    'Visa / Mastercard',
    name: 'credit_card',
    desc: '',
    args: [],
  );

  String get criminal_case => Intl.message(
    'Criminal Case',
    name: 'criminal_case',
    desc: '',
    args: [],
  );

  String get cuponApplied => Intl.message(
    'Coupon applied successfully',
    name: 'cuponApplied',
    desc: '',
    args: [],
  );

  String get cuponExpired => Intl.message(
    'Coupon has expired',
    name: 'cuponExpired',
    desc: '',
    args: [],
  );

  String get currency => Intl.message(
    'EGP',
    name: 'currency',
    desc: '',
    args: [],
  );

  String get currentNow => Intl.message(
    'Current',
    name: 'currentNow',
    desc: '',
    args: [],
  );

  String get currentPassword => Intl.message(
    'Current Password',
    name: 'currentPassword',
    desc: '',
    args: [],
  );

  String get cvv => Intl.message(
    'CVV',
    name: 'cvv',
    desc: '',
    args: [],
  );

  String get cycleAndPeriodError => Intl.message(
    'Please check your period and cycle length values.',
    name: 'cycleAndPeriodError',
    desc: '',
    args: [],
  );

  String get cycleLengthMax => Intl.message(
    'The cycle length must not be greater than 35.',
    name: 'cycleLengthMax',
    desc: '',
    args: [],
  );

  String get cycleLengthMin => Intl.message(
    'Cycle Length Must Be At Least 21 Days',
    name: 'cycleLengthMin',
    desc: '',
    args: [],
  );

  String get cyclePhase => Intl.message(
    'Menstrual Cycle Phase',
    name: 'cyclePhase',
    desc: '',
    args: [],
  );

  String get dailyReminder => Intl.message(
    'Every day',
    name: 'dailyReminder',
    desc: '',
    args: [],
  );

  String get daily_does => Intl.message(
    'Your Daily Does',
    name: 'daily_does',
    desc: '',
    args: [],
  );

  String get dashboard => Intl.message(
    'Dashboard',
    name: 'dashboard',
    desc: '',
    args: [],
  );

  String get date => Intl.message(
    'Date',
    name: 'date',
    desc: '',
    args: [],
  );

  String get date2 => Intl.message(
    'Date',
    name: 'date2',
    desc: '',
    args: [],
  );

  String get datePeriods => Intl.message(
    'day/month/year',
    name: 'datePeriods',
    desc: '',
    args: [],
  );

  String get day => Intl.message(
    'Day',
    name: 'day',
    desc: '',
    args: [],
  );

  String get dayOfLastMenstrual => Intl.message(
    'Select the first day of the last menstrual cycle',
    name: 'dayOfLastMenstrual',
    desc: '',
    args: [],
  );

  String get days => Intl.message(
    'Days',
    name: 'days',
    desc: '',
    args: [],
  );

  String get decisions => Intl.message(
    'Excellence Decisions',
    name: 'decisions',
    desc: '',
    args: [],
  );

  String get defaultAddress => Intl.message(
    'Default Address',
    name: 'defaultAddress',
    desc: '',
    args: [],
  );

  String get defultAddress => Intl.message(
    'Default Address',
    name: 'defultAddress',
    desc: '',
    args: [],
  );

  String get degreeObesity => Intl.message(
    'Third Degree Obesity',
    name: 'degreeObesity',
    desc: '',
    args: [],
  );

  String get deleteAddressConfirmation => Intl.message(
    'Are you sure you want to delete this address?',
    name: 'deleteAddressConfirmation',
    desc: '',
    args: [],
  );

  String get deleteCompletely => Intl.message(
    'Delete the medication completely',
    name: 'deleteCompletely',
    desc: '',
    args: [],
  );

  String get deleteOnlyForToday => Intl.message(
    'Delete only for today',
    name: 'deleteOnlyForToday',
    desc: '',
    args: [],
  );

  String get deletePhoto => Intl.message(
    'Delete photo',
    name: 'deletePhoto',
    desc: '',
    args: [],
  );

  String get delete_account => Intl.message(
    'Delete Account',
    name: 'delete_account',
    desc: '',
    args: [],
  );

  String get delete_address_completed => Intl.message(
    'Address Deleted Successfully',
    name: 'delete_address_completed',
    desc: '',
    args: [],
  );

  String get delete_address_confirmation => Intl.message(
    'Are you sure you want to delete this address?',
    name: 'delete_address_confirmation',
    desc: '',
    args: [],
  );

  String get delete_failed => Intl.message(
    'Failed To Delete Child Data',
    name: 'delete_failed',
    desc: '',
    args: [],
  );

  String get delete_photo => Intl.message(
    'Delete Photo',
    name: 'delete_photo',
    desc: '',
    args: [],
  );

  String get deleted_successfully => Intl.message(
    'Child Data Deleted Successfully',
    name: 'deleted_successfully',
    desc: '',
    args: [],
  );

  String get delivered => Intl.message(
    'Delivered',
    name: 'delivered',
    desc: '',
    args: [],
  );

  String get delivery => Intl.message(
    'Delivery',
    name: 'delivery',
    desc: '',
    args: [],
  );

  String get deliveryCost => Intl.message(
    'Delivery cost',
    name: 'deliveryCost',
    desc: '',
    args: [],
  );

  String get deliveryFee => Intl.message(
    'Delivery Fee',
    name: 'deliveryFee',
    desc: '',
    args: [],
  );

  String get deliveryLocation => Intl.message(
    'Delivery Location',
    name: 'deliveryLocation',
    desc: '',
    args: [],
  );

  String get deliveryValue => Intl.message(
    'Delivery Value',
    name: 'deliveryValue',
    desc: '',
    args: [],
  );

  String get delivery_address => Intl.message(
    'Delivery address',
    name: 'delivery_address',
    desc: '',
    args: [],
  );

  String get delivery_process_title => Intl.message(
    'Delivery Process',
    name: 'delivery_process_title',
    desc: '',
    args: [],
  );

  String get description => Intl.message(
    'Description',
    name: 'description',
    desc: '',
    args: [],
  );

  String get details => Intl.message(
    'Details',
    name: 'details',
    desc: '',
    args: [],
  );

  String get detailss => Intl.message(
    'Details',
    name: 'detailss',
    desc: '',
    args: [],
  );

  String get diary => Intl.message(
    'The Diary',
    name: 'diary',
    desc: '',
    args: [],
  );

  String get diastolicBloodPressureMeasurement => Intl.message(
    'Diastolic (low) blood pressure measurement',
    name: 'diastolicBloodPressureMeasurement',
    desc: '',
    args: [],
  );

  String get didntReceiveCode => Intl.message(
    'Didn\'t receive the code?',
    name: 'didntReceiveCode',
    desc: '',
    args: [],
  );

  String get discount => Intl.message(
    'Discount',
    name: 'discount',
    desc: '',
    args: [],
  );

  String get do_you_have_a_comment => Intl.message(
    'Do you have a comment?',
    name: 'do_you_have_a_comment',
    desc: '',
    args: [],
  );

  String get dob => Intl.message(
    'Date OF Birth',
    name: 'dob',
    desc: '',
    args: [],
  );

  String get done => Intl.message(
    'Done',
    name: 'done',
    desc: '',
    args: [],
  );

  String get doneSchedule => Intl.message(
    'Notifications scheduled successfully',
    name: 'doneSchedule',
    desc: '',
    args: [],
  );

  String get dontHaveAnAccount => Intl.message(
    'Don\'t have an account?',
    name: 'dontHaveAnAccount',
    desc: '',
    args: [],
  );

  String get dontWorry => Intl.message(
    'Don\'t worry! It happens. Please enter the email address associated with your account.',
    name: 'dontWorry',
    desc: '',
    args: [],
  );

  String get dose => Intl.message(
    'Dose',
    name: 'dose',
    desc: '',
    args: [],
  );

  String get dragAndDrop => Intl.message(
    'or drag and drop',
    name: 'dragAndDrop',
    desc: '',
    args: [],
  );

  String get durationCycles => Intl.message(
    'Duration between cycles',
    name: 'durationCycles',
    desc: '',
    args: [],
  );

  String get earned => Intl.message(
    'Earned',
    name: 'earned',
    desc: '',
    args: [],
  );

  String get easierPrescriptions => Intl.message(
    'Easier prescriptions',
    name: 'easierPrescriptions',
    desc: '',
    args: [],
  );

  String get edit => Intl.message(
    'Edit',
    name: 'edit',
    desc: '',
    args: [],
  );

  String get editAddress => Intl.message(
    'Edit Address',
    name: 'editAddress',
    desc: '',
    args: [],
  );

  String get editEmail => Intl.message(
    'Edit Email',
    name: 'editEmail',
    desc: '',
    args: [],
  );

  String get editLocation => Intl.message(
    'Edit Location',
    name: 'editLocation',
    desc: '',
    args: [],
  );

  String get editMedicne => Intl.message(
    'Edit Medicine',
    name: 'editMedicne',
    desc: '',
    args: [],
  );

  String get editPassword => Intl.message(
    'Edit Password',
    name: 'editPassword',
    desc: '',
    args: [],
  );

  String get editPersonalInfo => Intl.message(
    'Edit Personal Information',
    name: 'editPersonalInfo',
    desc: '',
    args: [],
  );

  String get editPhoneNumber => Intl.message(
    'Edit Phone Number',
    name: 'editPhoneNumber',
    desc: '',
    args: [],
  );

  String get editProfile => Intl.message(
    'Edit Profile',
    name: 'editProfile',
    desc: '',
    args: [],
  );

  String get edit_address => Intl.message(
    'Edit Address',
    name: 'edit_address',
    desc: '',
    args: [],
  );

  String get edit_personal_information => Intl.message(
    'Edit Personal Information',
    name: 'edit_personal_information',
    desc: '',
    args: [],
  );

  String get edit_profile => Intl.message(
    'Edit Profile',
    name: 'edit_profile',
    desc: '',
    args: [],
  );

  String get electricPay => Intl.message(
    'Electronic payment',
    name: 'electricPay',
    desc: '',
    args: [],
  );

  String get email => Intl.message(
    'Email',
    name: 'email',
    desc: '',
    args: [],
  );

  String get emailNotFound => Intl.message(
    'Email Not Found',
    name: 'emailNotFound',
    desc: '',
    args: [],
  );

  String get english => Intl.message(
    'English',
    name: 'english',
    desc: '',
    args: [],
  );

  String get enterAddress => Intl.message(
    'Enter Address',
    name: 'enterAddress',
    desc: '',
    args: [],
  );

  String get enterApartmentNumber => Intl.message(
    'Enter Apartment Number',
    name: 'enterApartmentNumber',
    desc: '',
    args: [],
  );

  String get enterBuildingNumber => Intl.message(
    'Enter Building Number',
    name: 'enterBuildingNumber',
    desc: '',
    args: [],
  );

  String get enterCurrentPassword => Intl.message(
    'Enter your current password here',
    name: 'enterCurrentPassword',
    desc: '',
    args: [],
  );

  String get enterEmailHere => Intl.message(
    'Enter email here',
    name: 'enterEmailHere',
    desc: '',
    args: [],
  );

  String get enterFloorNumber => Intl.message(
    'Enter Floor Number',
    name: 'enterFloorNumber',
    desc: '',
    args: [],
  );

  String get enterGender => Intl.message(
    'Enter Gender',
    name: 'enterGender',
    desc: '',
    args: [],
  );

  String get enterGovernorate => Intl.message(
    'Enter your governorate here',
    name: 'enterGovernorate',
    desc: '',
    args: [],
  );

  String get enterHeight => Intl.message(
    'Enter Your Height',
    name: 'enterHeight',
    desc: '',
    args: [],
  );

  String get enterMeasurement => Intl.message(
    'Enter Measurement',
    name: 'enterMeasurement',
    desc: '',
    args: [],
  );

  String get enterMessage => Intl.message(
    'Enter your message here',
    name: 'enterMessage',
    desc: '',
    args: [],
  );

  String get enterName => Intl.message(
    'Enter your name here',
    name: 'enterName',
    desc: '',
    args: [],
  );

  String get enterNewPasswordHere => Intl.message(
    'Enter new password here',
    name: 'enterNewPasswordHere',
    desc: '',
    args: [],
  );

  String get enterOfficeLocationFromMap => Intl.message(
    'Enter your office location from the map',
    name: 'enterOfficeLocationFromMap',
    desc: '',
    args: [],
  );

  String get enterPasswordAtLeast8Characters => Intl.message(
    'Password must be at least 8 characters',
    name: 'enterPasswordAtLeast8Characters',
    desc: '',
    args: [],
  );

  String get enterPasswordHere => Intl.message(
    'Enter password here',
    name: 'enterPasswordHere',
    desc: '',
    args: [],
  );

  String get enterPhoneNumberHere => Intl.message(
    'Enter phone number here',
    name: 'enterPhoneNumberHere',
    desc: '',
    args: [],
  );

  String get enterTheNewPasswordHere => Intl.message(
    'Enter new password here',
    name: 'enterTheNewPasswordHere',
    desc: '',
    args: [],
  );

  String get enterTheSiteHere => Intl.message(
    'Enter the site here',
    name: 'enterTheSiteHere',
    desc: '',
    args: [],
  );

  String get enterValidEmailAddress => Intl.message(
    'Please enter a valid email address',
    name: 'enterValidEmailAddress',
    desc: '',
    args: [],
  );

  String get enterValidName => Intl.message(
    'Please enter a valid name',
    name: 'enterValidName',
    desc: '',
    args: [],
  );

  String get enterValidPassword => Intl.message(
    'Please enter a valid password',
    name: 'enterValidPassword',
    desc: '',
    args: [],
  );

  String get enterValidPhoneNumber => Intl.message(
    'Please enter a valid phone number',
    name: 'enterValidPhoneNumber',
    desc: '',
    args: [],
  );

  String get enterVerificationCode => Intl.message(
    'Enter verification code',
    name: 'enterVerificationCode',
    desc: '',
    args: [],
  );

  String get enterWeight => Intl.message(
    'Enter Your Weight',
    name: 'enterWeight',
    desc: '',
    args: [],
  );

  String get enter_address => Intl.message(
    'Enter address here',
    name: 'enter_address',
    desc: '',
    args: [],
  );

  String get enter_apartment_number => Intl.message(
    'Enter apartment number here',
    name: 'enter_apartment_number',
    desc: '',
    args: [],
  );

  String get enter_building_number => Intl.message(
    'Enter building number here',
    name: 'enter_building_number',
    desc: '',
    args: [],
  );

  String get enter_card_number => Intl.message(
    'Enter card number here',
    name: 'enter_card_number',
    desc: '',
    args: [],
  );

  String get enter_cardholder_name => Intl.message(
    'Enter cardholder name here',
    name: 'enter_cardholder_name',
    desc: '',
    args: [],
  );

  String get enter_floor_number => Intl.message(
    'Enter floor number here',
    name: 'enter_floor_number',
    desc: '',
    args: [],
  );

  String get enter_medicine_name => Intl.message(
    'Enter medicine name',
    name: 'enter_medicine_name',
    desc: '',
    args: [],
  );

  String get enter_name_here => Intl.message(
    'Enter your name here',
    name: 'enter_name_here',
    desc: '',
    args: [],
  );

  String get enter_phone_number_here => Intl.message(
    'Enter Phone Number Here',
    name: 'enter_phone_number_here',
    desc: '',
    args: [],
  );

  String get enter_street_num => Intl.message(
    'Enter street number/name',
    name: 'enter_street_num',
    desc: '',
    args: [],
  );

  String get enternewDate => Intl.message(
    'Enter New Date',
    name: 'enternewDate',
    desc: '',
    args: [],
  );

  String get enterstreet => Intl.message(
    'Street number/name',
    name: 'enterstreet',
    desc: '',
    args: [],
  );

  String get error => Intl.message(
    'Error',
    name: 'error',
    desc: '',
    args: [],
  );

  String get errorAddTime => Intl.message(
    'Please add at least one time',
    name: 'errorAddTime',
    desc: '',
    args: [],
  );

  String get errorEnterMedicineName => Intl.message(
    'Please enter the medicine name',
    name: 'errorEnterMedicineName',
    desc: '',
    args: [],
  );

  String get errorSelectOnceDay => Intl.message(
    'Please select a day for one-time reminder',
    name: 'errorSelectOnceDay',
    desc: '',
    args: [],
  );

  String get errorSelectSpecificDays => Intl.message(
    'Please select specific days',
    name: 'errorSelectSpecificDays',
    desc: '',
    args: [],
  );

  String get error_preparing_data => Intl.message(
    'Error occurred while preparing data. Please try again.',
    name: 'error_preparing_data',
    desc: '',
    args: [],
  );

  String get evening => Intl.message(
    'Evening',
    name: 'evening',
    desc: '',
    args: [],
  );

  String get everyDay => Intl.message(
    'Every Day',
    name: 'everyDay',
    desc: '',
    args: [],
  );

  String get every_day => Intl.message(
    'Every Day',
    name: 'every_day',
    desc: '',
    args: [],
  );

  String get exit_app => Intl.message(
    'Exit App',
    name: 'exit_app',
    desc: '',
    args: [],
  );

  String get expectedDOBirth => Intl.message(
    'Expected Date of Birth',
    name: 'expectedDOBirth',
    desc: '',
    args: [],
  );

  String get expired => Intl.message(
    'Expired',
    name: 'expired',
    desc: '',
    args: [],
  );

  String get expired_at => Intl.message(
    'Expired At',
    name: 'expired_at',
    desc: '',
    args: [],
  );

  String get expiresIn => Intl.message(
    'Expires in',
    name: 'expiresIn',
    desc: '',
    args: [],
  );

  String get expiry_date => Intl.message(
    'Expiry Date',
    name: 'expiry_date',
    desc: '',
    args: [],
  );

  String get facebook => Intl.message(
    'Facebook',
    name: 'facebook',
    desc: '',
    args: [],
  );

  String get failed_to_add_medicine => Intl.message(
    'Failed to add medicine',
    name: 'failed_to_add_medicine',
    desc: '',
    args: [],
  );

  String get failed_to_add_time => Intl.message(
    'Failed to add time',
    name: 'failed_to_add_time',
    desc: '',
    args: [],
  );

  String get fasting => Intl.message(
    'Fasting',
    name: 'fasting',
    desc: '',
    args: [],
  );

  String get favourite => Intl.message(
    'Favourite',
    name: 'favourite',
    desc: '',
    args: [],
  );

  String get favouriteEmpty => Intl.message(
    'Empty Favourite List',
    name: 'favouriteEmpty',
    desc: '',
    args: [],
  );

  String get features => Intl.message(
    'Features',
    name: 'features',
    desc: '',
    args: [],
  );

  String get fees => Intl.message(
    'Fees',
    name: 'fees',
    desc: '',
    args: [],
  );

  String get feildRequired => Intl.message(
    'Required Field',
    name: 'feildRequired',
    desc: '',
    args: [],
  );

  String get feildRequiredalso => Intl.message(
    'This field must not be empty',
    name: 'feildRequiredalso',
    desc: '',
    args: [],
  );

  String get female => Intl.message(
    'female',
    name: 'female',
    desc: '',
    args: [],
  );

  String get fertility_calendar => Intl.message(
    'Fertility Calendar',
    name: 'fertility_calendar',
    desc: '',
    args: [],
  );

  String get fetalDimensions => Intl.message(
    'Fetal Dimensions',
    name: 'fetalDimensions',
    desc: '',
    args: [],
  );

  String get files => Intl.message(
    'Files',
    name: 'files',
    desc: '',
    args: [],
  );

  String get fill => Intl.message(
    'Enter Here',
    name: 'fill',
    desc: '',
    args: [],
  );

  String get find_yourDoes => Intl.message(
    'Find Your Does',
    name: 'find_yourDoes',
    desc: '',
    args: [],
  );

  String get firstDayOfLastMenstrualCycle => Intl.message(
    'First Day Of The Last Menstrual Cycle',
    name: 'firstDayOfLastMenstrualCycle',
    desc: '',
    args: [],
  );

  String get firstThird => Intl.message(
    'First Third',
    name: 'firstThird',
    desc: '',
    args: [],
  );

  String get floorNumber => Intl.message(
    'Floor Number',
    name: 'floorNumber',
    desc: '',
    args: [],
  );

  String get floor_number => Intl.message(
    'Floor Number',
    name: 'floor_number',
    desc: '',
    args: [],
  );

  String get forgotPassword => Intl.message(
    'Forgot Password?',
    name: 'forgotPassword',
    desc: '',
    args: [],
  );

  String get friday => Intl.message(
    'Friday',
    name: 'friday',
    desc: '',
    args: [],
  );

  String get gender => Intl.message(
    'Gender',
    name: 'gender',
    desc: '',
    args: [],
  );

  String get gift => Intl.message(
    'Gift',
    name: 'gift',
    desc: '',
    args: [],
  );

  String get government => Intl.message(
    'Government',
    name: 'government',
    desc: '',
    args: [],
  );

  String get governorate => Intl.message(
    'Governorate',
    name: 'governorate',
    desc: '',
    args: [],
  );

  String get guest => Intl.message(
    'Guest',
    name: 'guest',
    desc: '',
    args: [],
  );

  String get guide => Intl.message(
    'Lawyer\'s Guide',
    name: 'guide',
    desc: '',
    args: [],
  );

  String get healthMeasure => Intl.message(
    'Ovulation and Period Calculator',
    name: 'healthMeasure',
    desc: '',
    args: [],
  );

  String get height => Intl.message(
    'Height',
    name: 'height',
    desc: '',
    args: [],
  );

  String get hello => Intl.message(
    'Hello',
    name: 'hello',
    desc: '',
    args: [],
  );

  String get home => Intl.message(
    'Home',
    name: 'home',
    desc: '',
    args: [],
  );

  String get homeAddress => Intl.message(
    'Home',
    name: 'homeAddress',
    desc: '',
    args: [],
  );

  String get homeErrorSubtitle => Intl.message(
    'We couldn\'t load the home content. Check your internet connection and try again.',
    name: 'homeErrorSubtitle',
    desc: '',
    args: [],
  );

  String get homeErrorTitle => Intl.message(
    'Something went wrong',
    name: 'homeErrorTitle',
    desc: '',
    args: [],
  );

  String get home_address => Intl.message(
    'Home',
    name: 'home_address',
    desc: '',
    args: [],
  );

  String get hours => Intl.message(
    'Hours',
    name: 'hours',
    desc: '',
    args: [],
  );

  String get how_was_your_order => Intl.message(
    'How was your order?',
    name: 'how_was_your_order',
    desc: '',
    args: [],
  );

  String get idNumber => Intl.message(
    'ID Number',
    name: 'idNumber',
    desc: '',
    args: [],
  );

  String get in_progress => Intl.message(
    'In Progress',
    name: 'in_progress',
    desc: '',
    args: [],
  );

  String get increment => Intl.message(
    'Increment',
    name: 'increment',
    desc: '',
    args: [],
  );

  String get insta => Intl.message(
    'Instagram',
    name: 'insta',
    desc: '',
    args: [],
  );

  String get installments => Intl.message(
    'Installments',
    name: 'installments',
    desc: '',
    args: [],
  );

  String get item => Intl.message(
    'Item',
    name: 'item',
    desc: '',
    args: [],
  );

  String get items => Intl.message(
    'items',
    name: 'items',
    desc: '',
    args: [],
  );

  String get justNow => Intl.message(
    'Just Now',
    name: 'justNow',
    desc: '',
    args: [],
  );

  String get kgm => Intl.message(
    'Kgm',
    name: 'kgm',
    desc: '',
    args: [],
  );

  String get landMark => Intl.message(
    'Landmark',
    name: 'landMark',
    desc: '',
    args: [],
  );

  String get language => Intl.message(
    'Language',
    name: 'language',
    desc: '',
    args: [],
  );

  String get latest => Intl.message(
    'Latest',
    name: 'latest',
    desc: '',
    args: [],
  );

  String get latestBloodPressureMeasurement => Intl.message(
    'The Latest Blood Pressure Measurement',
    name: 'latestBloodPressureMeasurement',
    desc: '',
    args: [],
  );

  String get latestSugarMeasurement => Intl.message(
    'The latest sugar measurement',
    name: 'latestSugarMeasurement',
    desc: '',
    args: [],
  );

  String get lawyer => Intl.message(
    'Lawyer',
    name: 'lawyer',
    desc: '',
    args: [],
  );

  String get leave_review => Intl.message(
    'Leave a Review',
    name: 'leave_review',
    desc: '',
    args: [],
  );

  String get less_rated => Intl.message(
    'Less Rated',
    name: 'less_rated',
    desc: '',
    args: [],
  );

  String get level => Intl.message(
    'Level',
    name: 'level',
    desc: '',
    args: [],
  );

  String get loaded => Intl.message(
    'Loaded successfully',
    name: 'loaded',
    desc: '',
    args: [],
  );

  String get loading => Intl.message(
    'Loading',
    name: 'loading',
    desc: '',
    args: [],
  );

  String get location => Intl.message(
    'Location On Map',
    name: 'location',
    desc: '',
    args: [],
  );

  String get login => Intl.message(
    'Login',
    name: 'login',
    desc: '',
    args: [],
  );

  String get loginRequired => Intl.message(
    'Login Required',
    name: 'loginRequired',
    desc: '',
    args: [],
  );

  String get loginUser => Intl.message(
    'Login as User',
    name: 'loginUser',
    desc: '',
    args: [],
  );

  String get logout => Intl.message(
    'Logout',
    name: 'logout',
    desc: '',
    args: [],
  );

  String get male => Intl.message(
    'Male',
    name: 'male',
    desc: '',
    args: [],
  );

  String get map => Intl.message(
    'Map',
    name: 'map',
    desc: '',
    args: [],
  );

  String get maryam_message => Intl.message(
    'Hello, I have a case related to a rental contract. Can we schedule a consultation?',
    name: 'maryam_message',
    desc: '',
    args: [],
  );

  String get maryam_mohammed => Intl.message(
    'Maryam Mohammed',
    name: 'maryam_mohammed',
    desc: '',
    args: [],
  );

  String get maxFileSize => Intl.message(
    '(Maximum file size: 25 MB)',
    name: 'maxFileSize',
    desc: '',
    args: [],
  );

  String get measuringBloodPressure => Intl.message(
    'Measuring Blood Pressure',
    name: 'measuringBloodPressure',
    desc: '',
    args: [],
  );

  String get measuringBloodSugar => Intl.message(
    'Measuring blood sugar',
    name: 'measuringBloodSugar',
    desc: '',
    args: [],
  );

  String get measuringSystolicBloodPressure => Intl.message(
    'Measuring systolic (high) blood pressure',
    name: 'measuringSystolicBloodPressure',
    desc: '',
    args: [],
  );

  String get medicalTips => Intl.message(
    'Medical Tips',
    name: 'medicalTips',
    desc: '',
    args: [],
  );

  String get medicalTipsServices => Intl.message(
    'Medical Tips',
    name: 'medicalTipsServices',
    desc: '',
    args: [],
  );

  String get medicationSchedule => Intl.message(
    'Medication Schedule',
    name: 'medicationSchedule',
    desc: '',
    args: [],
  );

  String get medicationSchedules => Intl.message(
    'Medication schedules',
    name: 'medicationSchedules',
    desc: '',
    args: [],
  );

  String get medication_schedules => Intl.message(
    'Medication Schedules',
    name: 'medication_schedules',
    desc: '',
    args: [],
  );

  String get medicineEditedSuccessfully => Intl.message(
    'Medicine Edited Successfully',
    name: 'medicineEditedSuccessfully',
    desc: '',
    args: [],
  );

  String get medicine_added => Intl.message(
    'Medicine Added Successfully',
    name: 'medicine_added',
    desc: '',
    args: [],
  );

  String get medicine_name => Intl.message(
    'Medicine Name',
    name: 'medicine_name',
    desc: '',
    args: [],
  );

  String get menstruation => Intl.message(
    'Menstruation',
    name: 'menstruation',
    desc: '',
    args: [],
  );

  String get message => Intl.message(
    'Message',
    name: 'message',
    desc: '',
    args: [],
  );

  String get messages => Intl.message(
    'Messages',
    name: 'messages',
    desc: '',
    args: [],
  );

  String get minutes => Intl.message(
    'Minutes',
    name: 'minutes',
    desc: '',
    args: [],
  );

  String get missedVac => Intl.message(
    'Missed Vaccines',
    name: 'missedVac',
    desc: '',
    args: [],
  );

  String get monday => Intl.message(
    'Monday',
    name: 'monday',
    desc: '',
    args: [],
  );

  String get morning => Intl.message(
    'Morning',
    name: 'morning',
    desc: '',
    args: [],
  );

  String get myAccount => Intl.message(
    'My Account',
    name: 'myAccount',
    desc: '',
    args: [],
  );

  String get myDosage => Intl.message(
    'My Dose',
    name: 'myDosage',
    desc: '',
    args: [],
  );

  String get myDose => Intl.message(
    'My Dose',
    name: 'myDose',
    desc: '',
    args: [],
  );

  String get myOrders => Intl.message(
    'My Orders',
    name: 'myOrders',
    desc: '',
    args: [],
  );

  String get myPoints => Intl.message(
    'My Points',
    name: 'myPoints',
    desc: '',
    args: [],
  );

  String get my_account => Intl.message(
    'My Account',
    name: 'my_account',
    desc: '',
    args: [],
  );

  String get my_addresses => Intl.message(
    'My Addresses',
    name: 'my_addresses',
    desc: '',
    args: [],
  );

  String get my_orders => Intl.message(
    'My Orders',
    name: 'my_orders',
    desc: '',
    args: [],
  );

  String get my_points => Intl.message(
    'My Points',
    name: 'my_points',
    desc: '',
    args: [],
  );

  String get name => Intl.message(
    'Name',
    name: 'name',
    desc: '',
    args: [],
  );

  String get name2 => Intl.message(
    'Name*',
    name: 'name2',
    desc: '',
    args: [],
  );

  String get nameOfMedicine => Intl.message(
    'Name of medicine',
    name: 'nameOfMedicine',
    desc: '',
    args: [],
  );

  String get nameOf_medicineReminder => Intl.message(
    'Name(example:Ibuprofen)',
    name: 'nameOf_medicineReminder',
    desc: '',
    args: [],
  );

  String get national_id_card => Intl.message(
    'National ID Card',
    name: 'national_id_card',
    desc: '',
    args: [],
  );

  String get networkError => Intl.message(
    'Network error. Check your internet connection.',
    name: 'networkError',
    desc: '',
    args: [],
  );

  String get newArrival => Intl.message(
    'newArrival',
    name: 'newArrival',
    desc: '',
    args: [],
  );

  String get newPass => Intl.message(
    'New Password',
    name: 'newPass',
    desc: '',
    args: [],
  );

  String get newPassword => Intl.message(
    'New Password',
    name: 'newPassword',
    desc: '',
    args: [],
  );

  String get newPregnaancy => Intl.message(
    'New Pregnancy',
    name: 'newPregnaancy',
    desc: '',
    args: [],
  );

  String get new_case_added => Intl.message(
    'New Case Added',
    name: 'new_case_added',
    desc: '',
    args: [],
  );

  String get new_case_added_message => Intl.message(
    'A new case has been added to your list. Tap here to view case details and manage it.',
    name: 'new_case_added_message',
    desc: '',
    args: [],
  );

  String get new_word => Intl.message(
    'New',
    name: 'new_word',
    desc: '',
    args: [],
  );

  String get newest => Intl.message(
    'Newest',
    name: 'newest',
    desc: '',
    args: [],
  );

  String get next => Intl.message(
    'Next',
    name: 'next',
    desc: '',
    args: [],
  );

  String get nextFertility => Intl.message(
    'Next Fertility',
    name: 'nextFertility',
    desc: '',
    args: [],
  );

  String get nextMenstruation => Intl.message(
    'Next Menstruation',
    name: 'nextMenstruation',
    desc: '',
    args: [],
  );

  String get no => Intl.message(
    'No',
    name: 'no',
    desc: '',
    args: [],
  );

  String get noAddressesFound => Intl.message(
    'No Addresses Found',
    name: 'noAddressesFound',
    desc: '',
    args: [],
  );

  String get noInternet => Intl.message(
    'No Internet connection',
    name: 'noInternet',
    desc: '',
    args: [],
  );

  String get noMedicationHasBeenAddedYet => Intl.message(
    'No medication has been added yet.',
    name: 'noMedicationHasBeenAddedYet',
    desc: '',
    args: [],
  );

  String get noOrder => Intl.message(
    'No Orders',
    name: 'noOrder',
    desc: '',
    args: [],
  );

  String get noOrders => Intl.message(
    'No Orders Yet',
    name: 'noOrders',
    desc: '',
    args: [],
  );

  String get noPhoneNumber => Intl.message(
    'No phone number registered',
    name: 'noPhoneNumber',
    desc: '',
    args: [],
  );

  String get noPointsEarned => Intl.message(
    'No Points Earned',
    name: 'noPointsEarned',
    desc: '',
    args: [],
  );

  String get noResultsFound => Intl.message(
    'No Results Found',
    name: 'noResultsFound',
    desc: '',
    args: [],
  );

  String get noReturns => Intl.message(
    'No Returns',
    name: 'noReturns',
    desc: '',
    args: [],
  );

  String get noSavedData => Intl.message(
    'No Saved Data',
    name: 'noSavedData',
    desc: '',
    args: [],
  );

  String get noVaccines => Intl.message(
    'No Vaccines',
    name: 'noVaccines',
    desc: '',
    args: [],
  );

  String get no_childred => Intl.message(
    'No children registered',
    name: 'no_childred',
    desc: '',
    args: [],
  );

  String get no_cities => Intl.message(
    'No cities available for delivery',
    name: 'no_cities',
    desc: '',
    args: [],
  );

  String get no_images => Intl.message(
    'No Images',
    name: 'no_images',
    desc: '',
    args: [],
  );

  String get no_medicine_yet => Intl.message(
    'No medicine has been added yet',
    name: 'no_medicine_yet',
    desc: '',
    args: [],
  );

  String get no_messages => Intl.message(
    'No Messages',
    name: 'no_messages',
    desc: '',
    args: [],
  );

  String get no_messages_message => Intl.message(
    'You have no messages yet. Please check back later.',
    name: 'no_messages_message',
    desc: '',
    args: [],
  );

  String get no_notifications => Intl.message(
    'No Notifications',
    name: 'no_notifications',
    desc: '',
    args: [],
  );

  String get no_notifications_message => Intl.message(
    'You have no notifications yet. Please check back later.',
    name: 'no_notifications_message',
    desc: '',
    args: [],
  );

  String get no_products_found => Intl.message(
    'No products found',
    name: 'no_products_found',
    desc: '',
    args: [],
  );

  String get no_resent => Intl.message(
    'No Recent Search Yet',
    name: 'no_resent',
    desc: '',
    args: [],
  );

  String get no_times_added_yet => Intl.message(
    'No times added yet',
    name: 'no_times_added_yet',
    desc: '',
    args: [],
  );

  String get nogitf => Intl.message(
    'No Gift',
    name: 'nogitf',
    desc: '',
    args: [],
  );

  String get notFound => Intl.message(
    'Resource not found.',
    name: 'notFound',
    desc: '',
    args: [],
  );

  String get notFoundCat => Intl.message(
    'No Categories Found',
    name: 'notFoundCat',
    desc: '',
    args: [],
  );

  String get notShippedYet => Intl.message(
    'Not shipped yet',
    name: 'notShippedYet',
    desc: '',
    args: [],
  );

  String get notValid => Intl.message(
    'Not Valid',
    name: 'notValid',
    desc: '',
    args: [],
  );

  String get note => Intl.message(
    'Note',
    name: 'note',
    desc: '',
    args: [],
  );

  String get notes => Intl.message(
    'Notes*',
    name: 'notes',
    desc: '',
    args: [],
  );

  String get notesHint => Intl.message(
    'Treatment and reliever for headaches',
    name: 'notesHint',
    desc: '',
    args: [],
  );

  String get notifications => Intl.message(
    'Notifications',
    name: 'notifications',
    desc: '',
    args: [],
  );

  String get notificationsScheduled => Intl.message(
    'Notifications Scheduled Successfully',
    name: 'notificationsScheduled',
    desc: '',
    args: [],
  );

  String get numberTransfer => Intl.message(
    'Transfer Number',
    name: 'numberTransfer',
    desc: '',
    args: [],
  );

  String get number_of_orders => Intl.message(
    'Number of Orders',
    name: 'number_of_orders',
    desc: '',
    args: [],
  );

  String get october_address => Intl.message(
    '6 October, Second District, Third Neighborhood, Building 516',
    name: 'october_address',
    desc: '',
    args: [],
  );

  String get officeLocation => Intl.message(
    'Specify your office or workplace location',
    name: 'officeLocation',
    desc: '',
    args: [],
  );

  String get officeLocationMap => Intl.message(
    'Office location',
    name: 'officeLocationMap',
    desc: '',
    args: [],
  );

  String get ok => Intl.message(
    'OK',
    name: 'ok',
    desc: '',
    args: [],
  );

  String get oldPass => Intl.message(
    'Old Password',
    name: 'oldPass',
    desc: '',
    args: [],
  );

  String get onDelivery => Intl.message(
    'On The Way',
    name: 'onDelivery',
    desc: '',
    args: [],
  );

  String get onb1Subtitle => Intl.message(
    'Your beauty and health... in one place',
    name: 'onb1Subtitle',
    desc: '',
    args: [],
  );

  String get onb1Title => Intl.message(
    'Your Beauty & Health',
    name: 'onb1Title',
    desc: '',
    args: [],
  );

  String get onb2Subtitle => Intl.message(
    'Provides free medical services',
    name: 'onb2Subtitle',
    desc: '',
    args: [],
  );

  String get onb2Title => Intl.message(
    'Smart Application',
    name: 'onb2Title',
    desc: '',
    args: [],
  );

  String get onb3Subtitle => Intl.message(
    'We provide all your needs of original beauty products',
    name: 'onb3Subtitle',
    desc: '',
    args: [],
  );

  String get onb3Title => Intl.message(
    'Original Products',
    name: 'onb3Title',
    desc: '',
    args: [],
  );

  String get once => Intl.message(
    'Once',
    name: 'once',
    desc: '',
    args: [],
  );

  String get onceReminder => Intl.message(
    'One-time reminder',
    name: 'onceReminder',
    desc: '',
    args: [],
  );

  String get oneTimeReminder => Intl.message(
    'One-Time Reminder',
    name: 'oneTimeReminder',
    desc: '',
    args: [],
  );

  String get onlyUpdateToday => Intl.message(
    'You can update today’s doses only',
    name: 'onlyUpdateToday',
    desc: '',
    args: [],
  );

  String get or => Intl.message(
    'Or',
    name: 'or',
    desc: '',
    args: [],
  );

  String get order => Intl.message(
    'Order',
    name: 'order',
    desc: '',
    args: [],
  );

  String get orderCacelled => Intl.message(
    'Your order has been cancelled',
    name: 'orderCacelled',
    desc: '',
    args: [],
  );

  String get orderDelivered => Intl.message(
    'Your order has been delivered',
    name: 'orderDelivered',
    desc: '',
    args: [],
  );

  String get orderDetails => Intl.message(
    'Order Details',
    name: 'orderDetails',
    desc: '',
    args: [],
  );

  String get orderIsNowConfirmed => Intl.message(
    'Your order has been confirmed',
    name: 'orderIsNowConfirmed',
    desc: '',
    args: [],
  );

  String get orderIsNowPending => Intl.message(
    'Your order is now pending',
    name: 'orderIsNowPending',
    desc: '',
    args: [],
  );

  String get orderMedicinesWithOrWithoutPrescription => Intl.message(
    'Order medicines with or without a prescription directly from the app and receive them at your doorstep.',
    name: 'orderMedicinesWithOrWithoutPrescription',
    desc: '',
    args: [],
  );

  String get orderNumber => Intl.message(
    'Order Number',
    name: 'orderNumber',
    desc: '',
    args: [],
  );

  String get orderRejected => Intl.message(
    'Your return request has been rejected',
    name: 'orderRejected',
    desc: '',
    args: [],
  );

  String get order_date => Intl.message(
    'Order Date',
    name: 'order_date',
    desc: '',
    args: [],
  );

  String get order_details => Intl.message(
    'Order Details',
    name: 'order_details',
    desc: '',
    args: [],
  );

  String get order_id => Intl.message(
    'Order ID',
    name: 'order_id',
    desc: '',
    args: [],
  );

  String get order_list => Intl.message(
    'Order list',
    name: 'order_list',
    desc: '',
    args: [],
  );

  String get order_number => Intl.message(
    'Order Number',
    name: 'order_number',
    desc: '',
    args: [],
  );

  String get order_placed => Intl.message(
    'Order Placed',
    name: 'order_placed',
    desc: '',
    args: [],
  );

  String get order_placed_success => Intl.message(
    'Your order has been placed successfully',
    name: 'order_placed_success',
    desc: '',
    args: [],
  );

  String get order_status => Intl.message(
    'Order Status',
    name: 'order_status',
    desc: '',
    args: [],
  );

  String get order_status_compiled => Intl.message(
    'New - Order compiled',
    name: 'order_status_compiled',
    desc: '',
    args: [],
  );

  String get order_status_canceled => Intl.message(
    'Canceled',
    name: 'order_status_canceled',
    desc: '',
    args: [],
  );

  String get order_status_confirmed => Intl.message(
    'Confirmed',
    name: 'order_status_confirmed',
    desc: '',
    args: [],
  );

  String get order_status_delivered => Intl.message(
    'Delivered',
    name: 'order_status_delivered',
    desc: '',
    args: [],
  );

  String get order_status_on_delivery => Intl.message(
    'New - Out for delivery',
    name: 'order_status_on_delivery',
    desc: '',
    args: [],
  );

  String get order_status_packed => Intl.message(
    'New - Order packed',
    name: 'order_status_packed',
    desc: '',
    args: [],
  );

  String get order_status_pending => Intl.message(
    'Order placed',
    name: 'order_status_pending',
    desc: '',
    args: [],
  );

  String get order_status_picking => Intl.message(
    'New - Order being picked',
    name: 'order_status_picking',
    desc: '',
    args: [],
  );

  String get order_status_preparing => Intl.message(
    'Preparing',
    name: 'order_status_preparing',
    desc: '',
    args: [],
  );

  String get order_status_shipping => Intl.message(
    'With courier',
    name: 'order_status_shipping',
    desc: '',
    args: [],
  );

  String get order_success => Intl.message(
    'Your order has been successfully placed',
    name: 'order_success',
    desc: '',
    args: [],
  );

  String get order_success_message => Intl.message(
    'Your order has been successfully placed and earned 70 bonus points',
    name: 'order_success_message',
    desc: '',
    args: [],
  );

  String get order_success_message2 => Intl.message(
    'Track your order or continue shopping',
    name: 'order_success_message2',
    desc: '',
    args: [],
  );

  String get ordered => Intl.message(
    'Ordered',
    name: 'ordered',
    desc: '',
    args: [],
  );

  String get orders => Intl.message(
    'Orders',
    name: 'orders',
    desc: '',
    args: [],
  );

  String get orders_current => Intl.message(
    'Current',
    name: 'orders_current',
    desc: '',
    args: [],
  );

  String get ovulation => Intl.message(
    'Ovulation',
    name: 'ovulation',
    desc: '',
    args: [],
  );

  String get ovulation_calculator => Intl.message(
    'Ovulation & Menstrual Calculator',
    name: 'ovulation_calculator',
    desc: '',
    args: [],
  );

  String get password => Intl.message(
    'Password',
    name: 'password',
    desc: '',
    args: [],
  );

  String get passwordChangedSuccessfully => Intl.message(
    'Password changed successfully',
    name: 'passwordChangedSuccessfully',
    desc: '',
    args: [],
  );

  String get passwordShouldBeAtLeast8Characters => Intl.message(
    'Password should be at least 8 characters',
    name: 'passwordShouldBeAtLeast8Characters',
    desc: '',
    args: [],
  );

  String get passwordsDoNotMatch => Intl.message(
    'Passwords do not match',
    name: 'passwordsDoNotMatch',
    desc: '',
    args: [],
  );

  String get past => Intl.message(
    'Previous',
    name: 'past',
    desc: '',
    args: [],
  );

  String get payment => Intl.message(
    'Payment',
    name: 'payment',
    desc: '',
    args: [],
  );

  String get paymentMethod => Intl.message(
    'Payment Method',
    name: 'paymentMethod',
    desc: '',
    args: [],
  );

  String get paymentOptions => Intl.message(
    'Payment Options',
    name: 'paymentOptions',
    desc: '',
    args: [],
  );

  String get paymentTool => Intl.message(
    'Payment Method',
    name: 'paymentTool',
    desc: '',
    args: [],
  );

  String get payment_methods => Intl.message(
    'Payment methods',
    name: 'payment_methods',
    desc: '',
    args: [],
  );

  String get pending => Intl.message(
    'Pending',
    name: 'pending',
    desc: '',
    args: [],
  );

  String get periodDays => Intl.message(
    'Period Days',
    name: 'periodDays',
    desc: '',
    args: [],
  );

  String get periodLength => Intl.message(
    'Period Length',
    name: 'periodLength',
    desc: '',
    args: [],
  );

  String get periodLengthMax => Intl.message(
    'The period length must not be greater than 10.',
    name: 'periodLengthMax',
    desc: '',
    args: [],
  );

  String get periodMin => Intl.message(
    'The Period Must Be At Least 3 Day',
    name: 'periodMin',
    desc: '',
    args: [],
  );

  String get personalDocuments => Intl.message(
    'Personal Documents',
    name: 'personalDocuments',
    desc: '',
    args: [],
  );

  String get personal_driver_license => Intl.message(
    'Driver\'s License',
    name: 'personal_driver_license',
    desc: '',
    args: [],
  );

  String get personal_information => Intl.message(
    'Personal Information',
    name: 'personal_information',
    desc: '',
    args: [],
  );

  String get personal_status => Intl.message(
    'Personal Status',
    name: 'personal_status',
    desc: '',
    args: [],
  );

  String get pharmacies => Intl.message(
    'Pharmacies',
    name: 'pharmacies',
    desc: '',
    args: [],
  );

  String get phase => Intl.message(
    'Phase',
    name: 'phase',
    desc: '',
    args: [],
  );

  String get phone => Intl.message(
    'Phone Call',
    name: 'phone',
    desc: '',
    args: [],
  );

  String get phoneNumber => Intl.message(
    'Phone Number',
    name: 'phoneNumber',
    desc: '',
    args: [],
  );

  String get phoneNumberExists => Intl.message(
    'Phone number already exists',
    name: 'phoneNumberExists',
    desc: '',
    args: [],
  );

  String get phoneNumberOptional => Intl.message(
    'Phone Number ( Optional )',
    name: 'phoneNumberOptional',
    desc: '',
    args: [],
  );

  String get phone_number => Intl.message(
    'Phone Number',
    name: 'phone_number',
    desc: '',
    args: [],
  );

  String get pickupLocation => Intl.message(
    'Pickup Location',
    name: 'pickupLocation',
    desc: '',
    args: [],
  );

  String get pictures => Intl.message(
    'Pictures',
    name: 'pictures',
    desc: '',
    args: [],
  );

  String get pinMustBe4DigitsLong => Intl.message(
    'Pin must be 4 digits long',
    name: 'pinMustBe4DigitsLong',
    desc: '',
    args: [],
  );

  String get pleaseAddMedications => Intl.message(
    'Please add medications and set reminders.',
    name: 'pleaseAddMedications',
    desc: '',
    args: [],
  );

  String get pleaseApplyCouponFirst => Intl.message(
    'Please apply your coupon first',
    name: 'pleaseApplyCouponFirst',
    desc: '',
    args: [],
  );

  String get pleaseEnter => Intl.message(
    'Required Field',
    name: 'pleaseEnter',
    desc: '',
    args: [],
  );

  String get pleaseEnterPassword => Intl.message(
    'Please enter a password',
    name: 'pleaseEnterPassword',
    desc: '',
    args: [],
  );

  String get pleaseEnterPhoneNumber => Intl.message(
    'Please Enter Phone Number For Contact',
    name: 'pleaseEnterPhoneNumber',
    desc: '',
    args: [],
  );

  String get pleaseEnterPin => Intl.message(
    'Please enter pin',
    name: 'pleaseEnterPin',
    desc: '',
    args: [],
  );

  String get pleaseEnterValidEmail => Intl.message(
    'Please enter a valid email',
    name: 'pleaseEnterValidEmail',
    desc: '',
    args: [],
  );

  String get pleaseEnterValidName => Intl.message(
    'Please enter a valid name',
    name: 'pleaseEnterValidName',
    desc: '',
    args: [],
  );

  String get pleaseEnterValidNumber => Intl.message(
    'Please enter a valid number',
    name: 'pleaseEnterValidNumber',
    desc: '',
    args: [],
  );

  String get pleaseEnterValidPhoneNumber => Intl.message(
    'Please enter a valid phone number',
    name: 'pleaseEnterValidPhoneNumber',
    desc: '',
    args: [],
  );

  String get pleaseEnterValidText => Intl.message(
    'Please enter a valid text',
    name: 'pleaseEnterValidText',
    desc: '',
    args: [],
  );

  String get pleaseLoginToAccessContent => Intl.message(
    'Please login to access this content',
    name: 'pleaseLoginToAccessContent',
    desc: '',
    args: [],
  );

  String get pleaseSelectGovernorate => Intl.message(
    'Please Select Governorate',
    name: 'pleaseSelectGovernorate',
    desc: '',
    args: [],
  );

  String get pleaseWait => Intl.message(
    'Please Wait',
    name: 'pleaseWait',
    desc: '',
    args: [],
  );

  String get please_add_at_least_one_time => Intl.message(
    'Please add at least one time',
    name: 'please_add_at_least_one_time',
    desc: '',
    args: [],
  );

  String get please_enter_medicine_name => Intl.message(
    'Please enter medicine name',
    name: 'please_enter_medicine_name',
    desc: '',
    args: [],
  );

  String get please_give_your_rating => Intl.message(
    'Please give your rating and opinion.',
    name: 'please_give_your_rating',
    desc: '',
    args: [],
  );

  String get please_select_address => Intl.message(
    'Please Select Address',
    name: 'please_select_address',
    desc: '',
    args: [],
  );

  String get please_select_at_least_one_day => Intl.message(
    'Please select at least one day',
    name: 'please_select_at_least_one_day',
    desc: '',
    args: [],
  );

  String get please_select_one_product => Intl.message(
    'Please select one product to review',
    name: 'please_select_one_product',
    desc: '',
    args: [],
  );

  String get please_select_one_product_to_refund => Intl.message(
    'Please select at least one product to refund',
    name: 'please_select_one_product_to_refund',
    desc: '',
    args: [],
  );

  String get please_select_reason => Intl.message(
    'Please Select a Reason',
    name: 'please_select_reason',
    desc: '',
    args: [],
  );

  String get point => Intl.message(
    'Point',
    name: 'point',
    desc: '',
    args: [],
  );

  String get points => Intl.message(
    'My Points',
    name: 'points',
    desc: '',
    args: [],
  );

  String get pointsEarned => Intl.message(
    'Points Earned',
    name: 'pointsEarned',
    desc: '',
    args: [],
  );

  String get pregnancyAndChildbirthCalculator => Intl.message(
    'Pregnancy and Childbirth Calculator',
    name: 'pregnancyAndChildbirthCalculator',
    desc: '',
    args: [],
  );

  String get pregnancyChance => Intl.message(
    'Pregnancy Chance',
    name: 'pregnancyChance',
    desc: '',
    args: [],
  );

  String get pregnancy_calculator => Intl.message(
    'Pregnancy & Delivery Calculator',
    name: 'pregnancy_calculator',
    desc: '',
    args: [],
  );

  String get pregnancy_chance => Intl.message(
    'Pregnancy Chance',
    name: 'pregnancy_chance',
    desc: '',
    args: [],
  );

  String get prescriptions => Intl.message(
    'Prescriptions',
    name: 'prescriptions',
    desc: '',
    args: [],
  );

  String get pressAgainToExit => Intl.message(
    'Press Again To Exit',
    name: 'pressAgainToExit',
    desc: '',
    args: [],
  );

  String get pressureSavedSuccessfully => Intl.message(
    'Pressure Saved Successfully',
    name: 'pressureSavedSuccessfully',
    desc: '',
    args: [],
  );

  String get previous => Intl.message(
    'Previous',
    name: 'previous',
    desc: '',
    args: [],
  );

  String get previousVaccines => Intl.message(
    'Previous Vaccines',
    name: 'previousVaccines',
    desc: '',
    args: [],
  );

  String get priceLabel => Intl.message(
    'Price',
    name: 'priceLabel',
    desc: '',
    args: [],
  );

  String get price_high_to_low => Intl.message(
    'Price: High to Low',
    name: 'price_high_to_low',
    desc: '',
    args: [],
  );

  String get price_low_to_high => Intl.message(
    'Price: Low to High',
    name: 'price_low_to_high',
    desc: '',
    args: [],
  );

  String get privacyPolicy => Intl.message(
    'Privacy Policy',
    name: 'privacyPolicy',
    desc: '',
    args: [],
  );

  String get privacy_policy => Intl.message(
    'Privacy Policy',
    name: 'privacy_policy',
    desc: '',
    args: [],
  );

  String get productDescription => Intl.message(
    'Product Description',
    name: 'productDescription',
    desc: '',
    args: [],
  );

  String get productDetails => Intl.message(
    'Product Details',
    name: 'productDetails',
    desc: '',
    args: [],
  );

  String get productNotAvailable => Intl.message(
    'Product not available',
    name: 'productNotAvailable',
    desc: '',
    args: [],
  );

  String get product_borken => Intl.message(
    'The product is broken or defective',
    name: 'product_borken',
    desc: '',
    args: [],
  );

  String get product_details => Intl.message(
    'Product Details',
    name: 'product_details',
    desc: '',
    args: [],
  );

  String get product_not_as_described => Intl.message(
    'Product not as described',
    name: 'product_not_as_described',
    desc: '',
    args: [],
  );

  String get product_not_suitable => Intl.message(
    'Product not suitable',
    name: 'product_not_suitable',
    desc: '',
    args: [],
  );

  String get professionalCard => Intl.message(
    'Professional Card',
    name: 'professionalCard',
    desc: '',
    args: [],
  );

  String get profile => Intl.message(
    'Profile',
    name: 'profile',
    desc: '',
    args: [],
  );

  String get promoCode => Intl.message(
    'Promo Code',
    name: 'promoCode',
    desc: '',
    args: [],
  );

  String get promoCodeExpired => Intl.message(
    'This Promo Code Expired',
    name: 'promoCodeExpired',
    desc: '',
    args: [],
  );

  String get qiCard => Intl.message(
    'InstaPay',
    name: 'qiCard',
    desc: '',
    args: [],
  );

  String get quantity => Intl.message(
    'Quantity',
    name: 'quantity',
    desc: '',
    args: [],
  );

  String get quantityPerDose => Intl.message(
    'Quantity Per Dose',
    name: 'quantityPerDose',
    desc: '',
    args: [],
  );

  String get quantityPerTime => Intl.message(
    'Quantity per time',
    name: 'quantityPerTime',
    desc: '',
    args: [],
  );

  String get quantity_per_time => Intl.message(
    'Quantity per Time',
    name: 'quantity_per_time',
    desc: '',
    args: [],
  );

  String get quickPharmacistConsultations => Intl.message(
    'Quick consultations with pharmacists and reminders for medication schedules.',
    name: 'quickPharmacistConsultations',
    desc: '',
    args: [],
  );

  String get random => Intl.message(
    'Random',
    name: 'random',
    desc: '',
    args: [],
  );

  String get readAll => Intl.message(
    'Mark All As Read',
    name: 'readAll',
    desc: '',
    args: [],
  );

  String get receiveTimeout => Intl.message(
    'Server took too long to respond.',
    name: 'receiveTimeout',
    desc: '',
    args: [],
  );

  String get received_wrong_product => Intl.message(
    'Received wrong product',
    name: 'received_wrong_product',
    desc: '',
    args: [],
  );

  String get recipient => Intl.message(
    'Recipient',
    name: 'recipient',
    desc: '',
    args: [],
  );

  String get recipientPhone => Intl.message(
    'Recipient Phone',
    name: 'recipientPhone',
    desc: '',
    args: [],
  );

  String get redeemedAt => Intl.message(
    'Spent at',
    name: 'redeemedAt',
    desc: '',
    args: [],
  );

  String get refund_amount => Intl.message(
    'Refund Amount',
    name: 'refund_amount',
    desc: '',
    args: [],
  );

  String get refused => Intl.message(
    'Refused',
    name: 'refused',
    desc: '',
    args: [],
  );

  String get rejected => Intl.message(
    'Rejected',
    name: 'rejected',
    desc: '',
    args: [],
  );

  String get remainDays => Intl.message(
    'Remaining days',
    name: 'remainDays',
    desc: '',
    args: [],
  );

  String get reminder => Intl.message(
    'Reminder',
    name: 'reminder',
    desc: '',
    args: [],
  );

  String get reminder_once => Intl.message(
    'Reminder Once',
    name: 'reminder_once',
    desc: '',
    args: [],
  );

  String get remove => Intl.message(
    'Remove',
    name: 'remove',
    desc: '',
    args: [],
  );

  String get removeFromCart => Intl.message(
    'Remove from Cart',
    name: 'removeFromCart',
    desc: '',
    args: [],
  );

  String get removeFromFavorites => Intl.message(
    'A item has been removed from favorites',
    name: 'removeFromFavorites',
    desc: '',
    args: [],
  );

  String get removeImage => Intl.message(
    'Remove Image',
    name: 'removeImage',
    desc: '',
    args: [],
  );

  String get reorder => Intl.message(
    'Reorder',
    name: 'reorder',
    desc: '',
    args: [],
  );

  String get repeat => Intl.message(
    'Repeat Reminder',
    name: 'repeat',
    desc: '',
    args: [],
  );

  String get repeatAlert => Intl.message(
    'Repeat alert',
    name: 'repeatAlert',
    desc: '',
    args: [],
  );

  String get repeat_alert => Intl.message(
    'Repeat Alert',
    name: 'repeat_alert',
    desc: '',
    args: [],
  );

  String get requestCancelled => Intl.message(
    'Request was cancelled.',
    name: 'requestCancelled',
    desc: '',
    args: [],
  );

  String get request_submitted_success => Intl.message(
    'Your request has been submitted successfully. We will respond to you as soon as possible.',
    name: 'request_submitted_success',
    desc: '',
    args: [],
  );

  String get request_submitted_successfully => Intl.message(
    'Your request has been submitted successfully',
    name: 'request_submitted_successfully',
    desc: '',
    args: [],
  );

  String get requiredFeilds => Intl.message(
    'Required Fields',
    name: 'requiredFeilds',
    desc: '',
    args: [],
  );

  String get resendOTP => Intl.message(
    'Resend OTP',
    name: 'resendOTP',
    desc: '',
    args: [],
  );

  String get response_message => Intl.message(
    'Hello, of course. I\'d be happy to help you with that. Does next Thursday at 10 AM work for you?',
    name: 'response_message',
    desc: '',
    args: [],
  );

  String get retry => Intl.message(
    'Try again',
    name: 'retry',
    desc: '',
    args: [],
  );

  String get returnPolicy => Intl.message(
    'Return Policy',
    name: 'returnPolicy',
    desc: '',
    args: [],
  );

  String get return_order_date => Intl.message(
    'Return Order Date:',
    name: 'return_order_date',
    desc: '',
    args: [],
  );

  String get return_order_id => Intl.message(
    'Return Order ID:',
    name: 'return_order_id',
    desc: '',
    args: [],
  );

  String get return_product => Intl.message(
    'Return Product',
    name: 'return_product',
    desc: '',
    args: [],
  );

  String get return_reason => Intl.message(
    'Return Reason',
    name: 'return_reason',
    desc: '',
    args: [],
  );

  String get returns => Intl.message(
    'Returns',
    name: 'returns',
    desc: '',
    args: [],
  );

  String get reviewYouData => Intl.message(
    'Review your account details here',
    name: 'reviewYouData',
    desc: '',
    args: [],
  );

  String get review_comment => Intl.message(
    'I recently purchased this shirt and unfortunately, it wasn\'t what I expected. The material was low quality and itchy. The design looked different from the pictures, and the colors were dull.',
    name: 'review_comment',
    desc: '',
    args: [],
  );

  String get reviews => Intl.message(
    'Reviews',
    name: 'reviews',
    desc: '',
    args: [],
  );

  String get reviewsAndrev => Intl.message(
    'Reviews & Ratings',
    name: 'reviewsAndrev',
    desc: '',
    args: [],
  );

  String get reviewsEmpty => Intl.message(
    'No Reviews',
    name: 'reviewsEmpty',
    desc: '',
    args: [],
  );

  String get roles => Intl.message(
    'Egyptian Laws',
    name: 'roles',
    desc: '',
    args: [],
  );

  String get saturday => Intl.message(
    'Saturday',
    name: 'saturday',
    desc: '',
    args: [],
  );

  String get save => Intl.message(
    'Save',
    name: 'save',
    desc: '',
    args: [],
  );

  String get saving => Intl.message(
    'Saving...',
    name: 'saving',
    desc: '',
    args: [],
  );

  String get search => Intl.message(
    'Search...',
    name: 'search',
    desc: '',
    args: [],
  );

  String get searchFor => Intl.message(
    'Search for...',
    name: 'searchFor',
    desc: '',
    args: [],
  );

  String get searchForYourDose => Intl.message(
    'Search for your dose',
    name: 'searchForYourDose',
    desc: '',
    args: [],
  );

  String get searchHistory => Intl.message(
    'Search history',
    name: 'searchHistory',
    desc: '',
    args: [],
  );

  String get secondThird => Intl.message(
    'Second Third',
    name: 'secondThird',
    desc: '',
    args: [],
  );

  String get sections => Intl.message(
    'Sections',
    name: 'sections',
    desc: '',
    args: [],
  );

  String get selectDate => Intl.message(
    'Please Select Date',
    name: 'selectDate',
    desc: '',
    args: [],
  );

  String get selectDays => Intl.message(
    'Select days',
    name: 'selectDays',
    desc: '',
    args: [],
  );

  String get select_days => Intl.message(
    'Select Days',
    name: 'select_days',
    desc: '',
    args: [],
  );

  String get send => Intl.message(
    'Send',
    name: 'send',
    desc: '',
    args: [],
  );

  String get sendCode => Intl.message(
    'Send Code',
    name: 'sendCode',
    desc: '',
    args: [],
  );

  String get sendTimeout => Intl.message(
    'Request took too long to send. Please try again.',
    name: 'sendTimeout',
    desc: '',
    args: [],
  );

  String get serverError => Intl.message(
    'Server error. Please try again later.',
    name: 'serverError',
    desc: '',
    args: [],
  );

  String get services => Intl.message(
    'Services',
    name: 'services',
    desc: '',
    args: [],
  );

  String get servicesServices => Intl.message(
    'Services',
    name: 'servicesServices',
    desc: '',
    args: [],
  );

  String get setTheTime => Intl.message(
    'Set the time',
    name: 'setTheTime',
    desc: '',
    args: [],
  );

  String get setYourLocation => Intl.message(
    'Set your current location or office location to make it easier for clients to find you',
    name: 'setYourLocation',
    desc: '',
    args: [],
  );

  String get shareProduct => Intl.message(
    'Check out this product',
    name: 'shareProduct',
    desc: '',
    args: [],
  );

  String get shipmentDetails => Intl.message(
    'Shipment Details',
    name: 'shipmentDetails',
    desc: '',
    args: [],
  );

  String get shipmentNumber => Intl.message(
    'Shipment Number',
    name: 'shipmentNumber',
    desc: '',
    args: [],
  );

  String get shipped => Intl.message(
    'Shipped',
    name: 'shipped',
    desc: '',
    args: [],
  );

  String get shipping => Intl.message(
    'Shipping',
    name: 'shipping',
    desc: '',
    args: [],
  );

  String get shippingAddress => Intl.message(
    'Shipping Address',
    name: 'shippingAddress',
    desc: '',
    args: [],
  );

  String get shopByProblem => Intl.message(
    'Shop By Problem',
    name: 'shopByProblem',
    desc: '',
    args: [],
  );

  String get show_more => Intl.message(
    'Show More',
    name: 'show_more',
    desc: '',
    args: [],
  );

  String get showless => Intl.message(
    'Show less',
    name: 'showless',
    desc: '',
    args: [],
  );

  String get sign_out => Intl.message(
    'Sign Out',
    name: 'sign_out',
    desc: '',
    args: [],
  );

  String get since_day => Intl.message(
    'Since a day',
    name: 'since_day',
    desc: '',
    args: [],
  );

  String get six_pm => Intl.message(
    '6 PM',
    name: 'six_pm',
    desc: '',
    args: [],
  );

  String get size => Intl.message(
    'Size',
    name: 'size',
    desc: '',
    args: [],
  );

  String get sizeNoAvaibleNow => Intl.message(
    'This size is not available right now. Please choose a different size!',
    name: 'sizeNoAvaibleNow',
    desc: '',
    args: [],
  );

  String get skip => Intl.message(
    'Skip',
    name: 'skip',
    desc: '',
    args: [],
  );

  String get skipLogin => Intl.message(
    'Skip Login',
    name: 'skipLogin',
    desc: '',
    args: [],
  );

  String get specialPackages => Intl.message(
    'Special packages',
    name: 'specialPackages',
    desc: '',
    args: [],
  );

  String get specializations => Intl.message(
    'Characteristics',
    name: 'specializations',
    desc: '',
    args: [],
  );

  String get specificDaysReminder => Intl.message(
    'Specific days',
    name: 'specificDaysReminder',
    desc: '',
    args: [],
  );

  String get specific_days => Intl.message(
    'Specific Days',
    name: 'specific_days',
    desc: '',
    args: [],
  );

  String get startNow => Intl.message(
    'Start Now',
    name: 'startNow',
    desc: '',
    args: [],
  );

  String get startShopping => Intl.message(
    'Start Shopping',
    name: 'startShopping',
    desc: '',
    args: [],
  );

  String get start_period_calc => Intl.message(
    'Start by calculating your cycle',
    name: 'start_period_calc',
    desc: '',
    args: [],
  );

  String get status => Intl.message(
    'Status',
    name: 'status',
    desc: '',
    args: [],
  );

  String get stopAlarm => Intl.message(
    'Stop Alarm',
    name: 'stopAlarm',
    desc: '',
    args: [],
  );

  String get strongPassword => Intl.message(
    'Protect your account with a strong password',
    name: 'strongPassword',
    desc: '',
    args: [],
  );

  String get submit_request => Intl.message(
    'Submit Request',
    name: 'submit_request',
    desc: '',
    args: [],
  );

  String get subtotal => Intl.message(
    'Subtotal',
    name: 'subtotal',
    desc: '',
    args: [],
  );

  String get success => Intl.message(
    'Success',
    name: 'success',
    desc: '',
    args: [],
  );

  String get successMessage => Intl.message(
    'Your request has been submitted successfully. We will get back to you as soon as possible',
    name: 'successMessage',
    desc: '',
    args: [],
  );

  String get sugarLevel => Intl.message(
    'Sugar Level',
    name: 'sugarLevel',
    desc: '',
    args: [],
  );

  String get suggestedForYou => Intl.message(
    'Suggested for you',
    name: 'suggestedForYou',
    desc: '',
    args: [],
  );

  String get suggested_for_you => Intl.message(
    'Suggested for you',
    name: 'suggested_for_you',
    desc: '',
    args: [],
  );

  String get sunday => Intl.message(
    'Sunday',
    name: 'sunday',
    desc: '',
    args: [],
  );

  String get sunday_june => Intl.message(
    'Sunday, June 15',
    name: 'sunday_june',
    desc: '',
    args: [],
  );

  String get table => Intl.message(
    'Table',
    name: 'table',
    desc: '',
    args: [],
  );

  String get take => Intl.message(
    'Take',
    name: 'take',
    desc: '',
    args: [],
  );

  String get takeFromPharamcy => Intl.message(
    'Receive From Pharmacy',
    name: 'takeFromPharamcy',
    desc: '',
    args: [],
  );

  String get terminated => Intl.message(
    'Terminated',
    name: 'terminated',
    desc: '',
    args: [],
  );

  String get termsAndConditions => Intl.message(
    'Terms and Conditions',
    name: 'termsAndConditions',
    desc: '',
    args: [],
  );

  String get terms_and_conditions => Intl.message(
    'Terms and Conditions',
    name: 'terms_and_conditions',
    desc: '',
    args: [],
  );

  String get testCase => Intl.message(
    'Test Case',
    name: 'testCase',
    desc: '',
    args: [],
  );

  String get thank_you_for_your_rating => Intl.message(
    'Thank you for your rating',
    name: 'thank_you_for_your_rating',
    desc: '',
    args: [],
  );

  String get the_dose_has_been_taken => Intl.message(
    'The dose has been taken',
    name: 'the_dose_has_been_taken',
    desc: '',
    args: [],
  );

  String get thereAreNoDosesForTheSpecifiedDay => Intl.message(
    'There are no doses for the specified day',
    name: 'thereAreNoDosesForTheSpecifiedDay',
    desc: '',
    args: [],
  );

  String get thereAreNoItems => Intl.message(
    'There are no items',
    name: 'thereAreNoItems',
    desc: '',
    args: [],
  );

  String get thirdThird => Intl.message(
    'Third Third',
    name: 'thirdThird',
    desc: '',
    args: [],
  );

  String get thursday => Intl.message(
    'Thursday',
    name: 'thursday',
    desc: '',
    args: [],
  );

  String get tik => Intl.message(
    'TikTok',
    name: 'tik',
    desc: '',
    args: [],
  );

  String get time => Intl.message(
    'Time',
    name: 'time',
    desc: '',
    args: [],
  );

  String get timeToTakeYourMedicine => Intl.message(
    'Time To Take Your Medicine',
    name: 'timeToTakeYourMedicine',
    desc: '',
    args: [],
  );

  String get today => Intl.message(
    'Today',
    name: 'today',
    desc: '',
    args: [],
  );

  String get top_rated => Intl.message(
    'Top Rated',
    name: 'top_rated',
    desc: '',
    args: [],
  );

  String get total => Intl.message(
    'Total',
    name: 'total',
    desc: '',
    args: [],
  );

  String get totalDeletion => Intl.message(
    'Total Deletion',
    name: 'totalDeletion',
    desc: '',
    args: [],
  );

  String get totalPrice => Intl.message(
    'Total Price',
    name: 'totalPrice',
    desc: '',
    args: [],
  );

  String get total_price => Intl.message(
    'Total Price',
    name: 'total_price',
    desc: '',
    args: [],
  );

  String get trackYourOrder => Intl.message(
    'Track your order',
    name: 'trackYourOrder',
    desc: '',
    args: [],
  );

  String get track_order => Intl.message(
    'Track Order',
    name: 'track_order',
    desc: '',
    args: [],
  );

  String get tuesday => Intl.message(
    'Tuesday',
    name: 'tuesday',
    desc: '',
    args: [],
  );

  String get unProcessableEntity => Intl.message(
    'Unprocessable entity. Please check your input.',
    name: 'unProcessableEntity',
    desc: '',
    args: [],
  );

  String get unauthorized => Intl.message(
    'Unauthorized. Incorrect Phone Number or Password.',
    name: 'unauthorized',
    desc: '',
    args: [],
  );

  String get unexpectedError => Intl.message(
    'An unexpected error occurred. Please try again later.',
    name: 'unexpectedError',
    desc: '',
    args: [],
  );

  String get unexpectedNetworkError => Intl.message(
    'Unexpected network error occurred.',
    name: 'unexpectedNetworkError',
    desc: '',
    args: [],
  );

  String get unit => Intl.message(
    'Unit of measure',
    name: 'unit',
    desc: '',
    args: [],
  );

  String get unknown => Intl.message(
    'Unknown',
    name: 'unknown',
    desc: '',
    args: [],
  );

  String get unknown_error => Intl.message(
    'Unknown error occurred',
    name: 'unknown_error',
    desc: '',
    args: [],
  );

  String get unnamedMedicine => Intl.message(
    'Unnamed medicine',
    name: 'unnamedMedicine',
    desc: '',
    args: [],
  );

  String get unsatisfied_with_quality => Intl.message(
    'Unsatisfied with quality',
    name: 'unsatisfied_with_quality',
    desc: '',
    args: [],
  );

  String get upload => Intl.message(
    'Upload Photo',
    name: 'upload',
    desc: '',
    args: [],
  );

  String get uploadPdf => Intl.message(
    'Upload Pdf Result',
    name: 'uploadPdf',
    desc: '',
    args: [],
  );

  String get uploadProfessionalCard => Intl.message(
    'Upload your law card and personal photo to confirm your identity and activate your account',
    name: 'uploadProfessionalCard',
    desc: '',
    args: [],
  );

  String get upload_image_here => Intl.message(
    'Upload image here',
    name: 'upload_image_here',
    desc: '',
    args: [],
  );

  String get upload_image_here_please => Intl.message(
    'Please upload a photo of your receipt',
    name: 'upload_image_here_please',
    desc: '',
    args: [],
  );

  String get upload_photos_here => Intl.message(
    'Upload photos here',
    name: 'upload_photos_here',
    desc: '',
    args: [],
  );

  String get upload_proof => Intl.message(
    'Upload a photo as proof of delivery',
    name: 'upload_proof',
    desc: '',
    args: [],
  );

  String get upload_the_conversion_image => Intl.message(
    'Upload the conversion image',
    name: 'upload_the_conversion_image',
    desc: '',
    args: [],
  );

  String get useAsShippingAddress => Intl.message(
    'Use as Shipping Address',
    name: 'useAsShippingAddress',
    desc: '',
    args: [],
  );

  String get use_as_shipping_address => Intl.message(
    'Use as shipping address',
    name: 'use_as_shipping_address',
    desc: '',
    args: [],
  );

  String get used => Intl.message(
    'Used',
    name: 'used',
    desc: '',
    args: [],
  );

  String get user => Intl.message(
    'User',
    name: 'user',
    desc: '',
    args: [],
  );

  String get vaccination_schedule => Intl.message(
    'Vaccination Schedule',
    name: 'vaccination_schedule',
    desc: '',
    args: [],
  );

  String get vaccineReminderTitle => Intl.message(
    'Reminder',
    name: 'vaccineReminderTitle',
    desc: '',
    args: [],
  );

  String get vaccineSchedule => Intl.message(
    'Vaccine Schedule',
    name: 'vaccineSchedule',
    desc: '',
    args: [],
  );

  String get valid => Intl.message(
    'Valid',
    name: 'valid',
    desc: '',
    args: [],
  );

  String get validateAddress => Intl.message(
    'Please enter a valid address',
    name: 'validateAddress',
    desc: '',
    args: [],
  );

  String get validateNumber => Intl.message(
    'Please enter a valid number',
    name: 'validateNumber',
    desc: '',
    args: [],
  );

  String get validateText => Intl.message(
    'This field is required',
    name: 'validateText',
    desc: '',
    args: [],
  );

  String get vehicle_license => Intl.message(
    'Transport Vehicle License',
    name: 'vehicle_license',
    desc: '',
    args: [],
  );

  String get verificationCodeDescription => Intl.message(
    'Enter the verification code sent to your email to verify your identity and ensure security.',
    name: 'verificationCodeDescription',
    desc: '',
    args: [],
  );

  String get viewHere => Intl.message(
    'View it here',
    name: 'viewHere',
    desc: '',
    args: [],
  );

  String get viewMapRoute => Intl.message(
    'View Map Route',
    name: 'viewMapRoute',
    desc: '',
    args: [],
  );

  String get viewMore => Intl.message(
    'View More',
    name: 'viewMore',
    desc: '',
    args: [],
  );

  String get view_order => Intl.message(
    'View Order',
    name: 'view_order',
    desc: '',
    args: [],
  );

  String get visa => Intl.message(
    'Visa',
    name: 'visa',
    desc: '',
    args: [],
  );

  String get volume => Intl.message(
    'Volume',
    name: 'volume',
    desc: '',
    args: [],
  );

  String get warinign => Intl.message(
    'Warning',
    name: 'warinign',
    desc: '',
    args: [],
  );

  String get we_will_reply_asap => Intl.message(
    'We will get back to you as soon as possible',
    name: 'we_will_reply_asap',
    desc: '',
    args: [],
  );

  String get wednesday => Intl.message(
    'Wednesday',
    name: 'wednesday',
    desc: '',
    args: [],
  );

  String get week => Intl.message(
    'Week',
    name: 'week',
    desc: '',
    args: [],
  );

  String get weeks => Intl.message(
    'Weeks',
    name: 'weeks',
    desc: '',
    args: [],
  );

  String get weight => Intl.message(
    'Weight',
    name: 'weight',
    desc: '',
    args: [],
  );

  String get weightRange => Intl.message(
    'Your Healthy Weight Range',
    name: 'weightRange',
    desc: '',
    args: [],
  );

  String get welcome => Intl.message(
    'Welcome',
    name: 'welcome',
    desc: '',
    args: [],
  );

  String get welcomeBack => Intl.message(
    'Welcome Back',
    name: 'welcomeBack',
    desc: '',
    args: [],
  );

  String get welcomeBackPleaseEnterYourDetails => Intl.message(
    'Welcome back! Please enter your details',
    name: 'welcomeBackPleaseEnterYourDetails',
    desc: '',
    args: [],
  );

  String get welcome_back_details => Intl.message(
    'Welcome back! Please enter your details',
    name: 'welcome_back_details',
    desc: '',
    args: [],
  );

  String get welcome_message => Intl.message(
    'Welcome! Ahmed Hassan 👋',
    name: 'welcome_message',
    desc: '',
    args: [],
  );

  String get with_delivery => Intl.message(
    'With Delivery',
    name: 'with_delivery',
    desc: '',
    args: [],
  );

  String get work => Intl.message(
    'Work',
    name: 'work',
    desc: '',
    args: [],
  );

  String get workAddress => Intl.message(
    'Work',
    name: 'workAddress',
    desc: '',
    args: [],
  );

  String get writeMessage => Intl.message(
    'Write a message...',
    name: 'writeMessage',
    desc: '',
    args: [],
  );

  String get write_your_comment_here => Intl.message(
    'Write your comment here...',
    name: 'write_your_comment_here',
    desc: '',
    args: [],
  );

  String get write_your_message_here => Intl.message(
    'Write your message here',
    name: 'write_your_message_here',
    desc: '',
    args: [],
  );

  String get wrong_email_pass => Intl.message(
    'Wrong email or password. Please try again.',
    name: 'wrong_email_pass',
    desc: '',
    args: [],
  );

  String get yes => Intl.message(
    'Yes',
    name: 'yes',
    desc: '',
    args: [],
  );

  String get yesRemove => Intl.message(
    'Yes, Remove',
    name: 'yesRemove',
    desc: '',
    args: [],
  );

  String get yes_delete => Intl.message(
    'Yes, delete',
    name: 'yes_delete',
    desc: '',
    args: [],
  );

  String get yesterday => Intl.message(
    'Yesterday',
    name: 'yesterday',
    desc: '',
    args: [],
  );

  String get youRecieved => Intl.message(
    'You Received',
    name: 'youRecieved',
    desc: '',
    args: [],
  );

  String get yourDailyDose => Intl.message(
    'Your daily dose',
    name: 'yourDailyDose',
    desc: '',
    args: [],
  );

  String get yourEmailAlready => Intl.message(
    'This Is Your Email Already',
    name: 'yourEmailAlready',
    desc: '',
    args: [],
  );

  String get yourEntries => Intl.message(
    'Your Entries',
    name: 'yourEntries',
    desc: '',
    args: [],
  );

  String get yourLocation => Intl.message(
    'Your Location',
    name: 'yourLocation',
    desc: '',
    args: [],
  );

  String get yourPharmacyInYourPocket => Intl.message(
    'Your pharmacy in your pocket',
    name: 'yourPharmacyInYourPocket',
    desc: '',
    args: [],
  );

  String get your_addresses => Intl.message(
    'Your Addresses',
    name: 'your_addresses',
    desc: '',
    args: [],
  );

  String get your_evaluation_matters_to_us => Intl.message(
    'Your evaluation matters to us',
    name: 'your_evaluation_matters_to_us',
    desc: '',
    args: [],
  );

  String get your_opinion_matters => Intl.message(
    'Your opinion matters to us and helps us improve your experience. If you have any additional comments, please feel free to share them with us!',
    name: 'your_opinion_matters',
    desc: '',
    args: [],
  );

  String get your_payment_methods => Intl.message(
    'Your Payment Methods',
    name: 'your_payment_methods',
    desc: '',
    args: [],
  );

  String get your_review_matters => Intl.message(
    'Your review matters',
    name: 'your_review_matters',
    desc: '',
    args: [],
  );

  String get yousif => Intl.message(
    'yousif',
    name: 'yousif',
    desc: '',
    args: [],
  );

  String get youtube => Intl.message(
    'Youtube',
    name: 'youtube',
    desc: '',
    args: [],
  );

  String get zainCach => Intl.message(
    'Vodafone Cash',
    name: 'zainCach',
    desc: '',
    args: [],
  );

  String get added => Intl.message(
    'Added',
    name: 'added',
    desc: '',
    args: [],
  );

  String get order_status_completed => Intl.message(
    'Completed',
    name: 'order_status_completed',
    desc: '',
    args: [],
  );

}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);

  @override
  Future<S> load(Locale locale) => S.load(locale);

  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
