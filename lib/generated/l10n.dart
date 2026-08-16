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
    final name =
        (locale.countryCode?.isEmpty ?? false)
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

  /// `yousif`
  String get yousif {
    return Intl.message('yousif', name: 'yousif', desc: '', args: []);
  }

  /// `Hello`
  String get hello {
    return Intl.message('Hello', name: 'hello', desc: '', args: []);
  }

  /// `Name*`
  String get name2 {
    return Intl.message('Name*', name: 'name2', desc: '', args: []);
  }

  /// `My App`
  String get appTitle {
    return Intl.message('My App', name: 'appTitle', desc: '', args: []);
  }

  /// `Change Language`
  String get changeLanguage {
    return Intl.message(
      'Change Language',
      name: 'changeLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Increment`
  String get increment {
    return Intl.message('Increment', name: 'increment', desc: '', args: []);
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! Please enter your details`
  String get welcome_back_details {
    return Intl.message(
      'Welcome back! Please enter your details',
      name: 'welcome_back_details',
      desc: '',
      args: [],
    );
  }

  /// `createAccountNowAndEnjoyExclusiveFeatures`
  String get createAccountNowAndEnjoyExclusiveFeatures {
    return Intl.message(
      'createAccountNowAndEnjoyExclusiveFeatures',
      name: 'createAccountNowAndEnjoyExclusiveFeatures',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phoneNumber {
    return Intl.message(
      'Phone Number',
      name: 'phoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter phone number here`
  String get enterPhoneNumberHere {
    return Intl.message(
      'Enter phone number here',
      name: 'enterPhoneNumberHere',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `User`
  String get user {
    return Intl.message('User', name: 'user', desc: '', args: []);
  }

  /// `Lawyer`
  String get lawyer {
    return Intl.message('Lawyer', name: 'lawyer', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Forgot Password?`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password?',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Skip Login`
  String get skipLogin {
    return Intl.message('Skip Login', name: 'skipLogin', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get dontHaveAnAccount {
    return Intl.message(
      'Don\'t have an account?',
      name: 'dontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back! Please enter your details`
  String get welcomeBackPleaseEnterYourDetails {
    return Intl.message(
      'Welcome back! Please enter your details',
      name: 'welcomeBackPleaseEnterYourDetails',
      desc: '',
      args: [],
    );
  }

  /// `Enter email here`
  String get enterEmailHere {
    return Intl.message(
      'Enter email here',
      name: 'enterEmailHere',
      desc: '',
      args: [],
    );
  }

  /// `Enter password here`
  String get enterPasswordHere {
    return Intl.message(
      'Enter password here',
      name: 'enterPasswordHere',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message('Or', name: 'or', desc: '', args: []);
  }

  /// `Don't worry! It happens. Please enter the email address associated with your account.`
  String get dontWorry {
    return Intl.message(
      'Don\'t worry! It happens. Please enter the email address associated with your account.',
      name: 'dontWorry',
      desc: '',
      args: [],
    );
  }

  /// `Send Code`
  String get sendCode {
    return Intl.message('Send Code', name: 'sendCode', desc: '', args: []);
  }

  /// `Please enter pin`
  String get pleaseEnterPin {
    return Intl.message(
      'Please enter pin',
      name: 'pleaseEnterPin',
      desc: '',
      args: [],
    );
  }

  /// `Pin must be 4 digits long`
  String get pinMustBe4DigitsLong {
    return Intl.message(
      'Pin must be 4 digits long',
      name: 'pinMustBe4DigitsLong',
      desc: '',
      args: [],
    );
  }

  /// `Enter verification code`
  String get enterVerificationCode {
    return Intl.message(
      'Enter verification code',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter the verification code sent to your email to verify your identity and ensure security.`
  String get verificationCodeDescription {
    return Intl.message(
      'Enter the verification code sent to your email to verify your identity and ensure security.',
      name: 'verificationCodeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive the code?`
  String get didntReceiveCode {
    return Intl.message(
      'Didn\'t receive the code?',
      name: 'didntReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resendOTP {
    return Intl.message('Resend OTP', name: 'resendOTP', desc: '', args: []);
  }

  /// `Create new password`
  String get createNewPassword {
    return Intl.message(
      'Create new password',
      name: 'createNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create a password to secure your account.`
  String get createNewPasswordDescription {
    return Intl.message(
      'Create a password to secure your account.',
      name: 'createNewPasswordDescription',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter new password here`
  String get enterNewPasswordHere {
    return Intl.message(
      'Enter new password here',
      name: 'enterNewPasswordHere',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password here`
  String get confirmNewPasswordHere {
    return Intl.message(
      'Confirm new password here',
      name: 'confirmNewPasswordHere',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match`
  String get passwordsDoNotMatch {
    return Intl.message(
      'Passwords do not match',
      name: 'passwordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordChangedSuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Done`
  String get done {
    return Intl.message('Done', name: 'done', desc: '', args: []);
  }

  /// `Create Lawyer Account`
  String get createLawyerAccount {
    return Intl.message(
      'Create Lawyer Account',
      name: 'createLawyerAccount',
      desc: '',
      args: [],
    );
  }

  /// `enter your Name, Phone and Email`
  String get createLawyerAccountDiscreption {
    return Intl.message(
      'enter your Name, Phone and Email',
      name: 'createLawyerAccountDiscreption',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Enter your name here`
  String get enterName {
    return Intl.message(
      'Enter your name here',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Protect your account with a strong password`
  String get strongPassword {
    return Intl.message(
      'Protect your account with a strong password',
      name: 'strongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Choose a secure password to ensure the protection of your personal account`
  String get chooseStrongPassword {
    return Intl.message(
      'Choose a secure password to ensure the protection of your personal account',
      name: 'chooseStrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Add your professional card and personal photo`
  String get addProfessionalCardAndPhoto {
    return Intl.message(
      'Add your professional card and personal photo',
      name: 'addProfessionalCardAndPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Upload your law card and personal photo to confirm your identity and activate your account`
  String get uploadProfessionalCard {
    return Intl.message(
      'Upload your law card and personal photo to confirm your identity and activate your account',
      name: 'uploadProfessionalCard',
      desc: '',
      args: [],
    );
  }

  /// `Add your professional card`
  String get addProfessionalCard {
    return Intl.message(
      'Add your professional card',
      name: 'addProfessionalCard',
      desc: '',
      args: [],
    );
  }

  /// `Click to upload`
  String get clickToUpload {
    return Intl.message(
      'Click to upload',
      name: 'clickToUpload',
      desc: '',
      args: [],
    );
  }

  /// `or drag and drop`
  String get dragAndDrop {
    return Intl.message(
      'or drag and drop',
      name: 'dragAndDrop',
      desc: '',
      args: [],
    );
  }

  /// `(Maximum file size: 25 MB)`
  String get maxFileSize {
    return Intl.message(
      '(Maximum file size: 25 MB)',
      name: 'maxFileSize',
      desc: '',
      args: [],
    );
  }

  /// `Specify your office or workplace location`
  String get officeLocation {
    return Intl.message(
      'Specify your office or workplace location',
      name: 'officeLocation',
      desc: '',
      args: [],
    );
  }

  /// `Set your current location or office location to make it easier for clients to find you`
  String get setYourLocation {
    return Intl.message(
      'Set your current location or office location to make it easier for clients to find you',
      name: 'setYourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Governorate`
  String get governorate {
    return Intl.message('Governorate', name: 'governorate', desc: '', args: []);
  }

  /// `Enter your governorate here`
  String get enterGovernorate {
    return Intl.message(
      'Enter your governorate here',
      name: 'enterGovernorate',
      desc: '',
      args: [],
    );
  }

  /// `Office location`
  String get officeLocationMap {
    return Intl.message(
      'Office location',
      name: 'officeLocationMap',
      desc: '',
      args: [],
    );
  }

  /// `Enter your office location from the map`
  String get enterOfficeLocationFromMap {
    return Intl.message(
      'Enter your office location from the map',
      name: 'enterOfficeLocationFromMap',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone_number {
    return Intl.message(
      'Phone Number',
      name: 'phone_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter Phone Number Here`
  String get enter_phone_number_here {
    return Intl.message(
      'Enter Phone Number Here',
      name: 'enter_phone_number_here',
      desc: '',
      args: [],
    );
  }

  /// `Add your profile picture`
  String get add_your_profile_picture {
    return Intl.message(
      'Add your profile picture',
      name: 'add_your_profile_picture',
      desc: '',
      args: [],
    );
  }

  /// `Account created successfully`
  String get accountCreatedSuccessfully {
    return Intl.message(
      'Account created successfully',
      name: 'accountCreatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Password should be at least 8 characters`
  String get passwordShouldBeAtLeast8Characters {
    return Intl.message(
      'Password should be at least 8 characters',
      name: 'passwordShouldBeAtLeast8Characters',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message('Home', name: 'home', desc: '', args: []);
  }

  /// `Cases`
  String get cases {
    return Intl.message('Cases', name: 'cases', desc: '', args: []);
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Welcome`
  String get welcome {
    return Intl.message('Welcome', name: 'welcome', desc: '', args: []);
  }

  /// `Ahmed Ibrahim`
  String get ahmed_ibrahim {
    return Intl.message(
      'Ahmed Ibrahim',
      name: 'ahmed_ibrahim',
      desc: '',
      args: [],
    );
  }

  /// `Number of Orders`
  String get number_of_orders {
    return Intl.message(
      'Number of Orders',
      name: 'number_of_orders',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Order`
  String get order {
    return Intl.message('Order', name: 'order', desc: '', args: []);
  }

  /// `Case`
  String get case_name {
    return Intl.message('Case', name: 'case_name', desc: '', args: []);
  }

  /// `Orders`
  String get orders {
    return Intl.message('Orders', name: 'orders', desc: '', args: []);
  }

  /// `Show More`
  String get show_more {
    return Intl.message('Show More', name: 'show_more', desc: '', args: []);
  }

  String get showless {
    return Intl.message('showless', name: 'showless', desc: '', args: []);
  }

  String get reviewsAndrev {
    return Intl.message(
      'reviewsAndrev',
      name: 'reviewsAndrev',
      desc: '',
      args: [],
    );
  }

  String get product_borken {
    return Intl.message(
      'product_borken',
      name: 'product_borken',
      desc: '',
      args: [],
    );
  }

  /// `Criminal Case`
  String get criminal_case {
    return Intl.message(
      'Criminal Case',
      name: 'criminal_case',
      desc: '',
      args: [],
    );
  }

  /// `Client Name`
  String get client_name {
    return Intl.message('Client Name', name: 'client_name', desc: '', args: []);
  }

  /// `Order Status`
  String get order_status {
    return Intl.message(
      'Order Status',
      name: 'order_status',
      desc: '',
      args: [],
    );
  }

  /// `Sunday, June 15`
  String get sunday_june {
    return Intl.message(
      'Sunday, June 15',
      name: 'sunday_june',
      desc: '',
      args: [],
    );
  }

  /// `6 PM`
  String get six_pm {
    return Intl.message('6 PM', name: 'six_pm', desc: '', args: []);
  }

  /// `Details`
  String get details {
    return Intl.message('Details', name: 'details', desc: '', args: []);
  }

  /// `Completed`
  String get completed_order {
    return Intl.message(
      'Completed',
      name: 'completed_order',
      desc: '',
      args: [],
    );
  }

  /// `Canceled`
  String get canceled {
    return Intl.message('Canceled', name: 'canceled', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `No Notifications`
  String get no_notifications {
    return Intl.message(
      'No Notifications',
      name: 'no_notifications',
      desc: '',
      args: [],
    );
  }

  /// `You have no notifications yet. Please check back later.`
  String get no_notifications_message {
    return Intl.message(
      'You have no notifications yet. Please check back later.',
      name: 'no_notifications_message',
      desc: '',
      args: [],
    );
  }

  /// `Back to Home`
  String get back_to_home {
    return Intl.message(
      'Back to Home',
      name: 'back_to_home',
      desc: '',
      args: [],
    );
  }

  /// `New Case Added`
  String get new_case_added {
    return Intl.message(
      'New Case Added',
      name: 'new_case_added',
      desc: '',
      args: [],
    );
  }

  /// `View Order`
  String get view_order {
    return Intl.message('View Order', name: 'view_order', desc: '', args: []);
  }

  /// `A new case has been added to your list. Tap here to view case details and manage it.`
  String get new_case_added_message {
    return Intl.message(
      'A new case has been added to your list. Tap here to view case details and manage it.',
      name: 'new_case_added_message',
      desc: '',
      args: [],
    );
  }

  /// `Since a day`
  String get since_day {
    return Intl.message('Since a day', name: 'since_day', desc: '', args: []);
  }

  /// `No Messages`
  String get no_messages {
    return Intl.message('No Messages', name: 'no_messages', desc: '', args: []);
  }

  /// `You have no messages yet. Please check back later.`
  String get no_messages_message {
    return Intl.message(
      'You have no messages yet. Please check back later.',
      name: 'no_messages_message',
      desc: '',
      args: [],
    );
  }

  /// `Maryam Mohammed`
  String get maryam_mohammed {
    return Intl.message(
      'Maryam Mohammed',
      name: 'maryam_mohammed',
      desc: '',
      args: [],
    );
  }

  /// `Hello, I have a case related to a rental contract. Can we schedule a consultation?`
  String get maryam_message {
    return Intl.message(
      'Hello, I have a case related to a rental contract. Can we schedule a consultation?',
      name: 'maryam_message',
      desc: '',
      args: [],
    );
  }

  /// `Hello, of course. I'd be happy to help you with that. Does next Thursday at 10 AM work for you?`
  String get response_message {
    return Intl.message(
      'Hello, of course. I\'d be happy to help you with that. Does next Thursday at 10 AM work for you?',
      name: 'response_message',
      desc: '',
      args: [],
    );
  }

  /// `Case Details`
  String get case_details {
    return Intl.message(
      'Case Details',
      name: 'case_details',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Files`
  String get files {
    return Intl.message('Files', name: 'files', desc: '', args: []);
  }

  /// `Click to view`
  String get click_to_view {
    return Intl.message(
      'Click to view',
      name: 'click_to_view',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get new_word {
    return Intl.message('New', name: 'new_word', desc: '', args: []);
  }

  /// `Coming`
  String get coming {
    return Intl.message('Coming', name: 'coming', desc: '', args: []);
  }

  /// `Search...`
  String get search {
    return Intl.message('Search...', name: 'search', desc: '', args: []);
  }

  /// `Write a message...`
  String get writeMessage {
    return Intl.message(
      'Write a message...',
      name: 'writeMessage',
      desc: '',
      args: [],
    );
  }

  /// `My Account`
  String get myAccount {
    return Intl.message('My Account', name: 'myAccount', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Library`
  String get library {
    return Intl.message('Library', name: 'library', desc: '', args: []);
  }

  /// `Excellence Decisions`
  String get decisions {
    return Intl.message(
      'Excellence Decisions',
      name: 'decisions',
      desc: '',
      args: [],
    );
  }

  /// `Egyptian Laws`
  String get roles {
    return Intl.message('Egyptian Laws', name: 'roles', desc: '', args: []);
  }

  /// `Lawyer's Guide`
  String get guide {
    return Intl.message('Lawyer\'s Guide', name: 'guide', desc: '', args: []);
  }

  /// `The Diary`
  String get diary {
    return Intl.message('The Diary', name: 'diary', desc: '', args: []);
  }

  /// `Characteristics`
  String get specializations {
    return Intl.message(
      'Characteristics',
      name: 'specializations',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message('Contact Us', name: 'contactUs', desc: '', args: []);
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'termsAndConditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `Professional Card`
  String get professionalCard {
    return Intl.message(
      'Professional Card',
      name: 'professionalCard',
      desc: '',
      args: [],
    );
  }

  /// `Your Location`
  String get yourLocation {
    return Intl.message(
      'Your Location',
      name: 'yourLocation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Email`
  String get editEmail {
    return Intl.message('Edit Email', name: 'editEmail', desc: '', args: []);
  }

  /// `Edit Phone Number`
  String get editPhoneNumber {
    return Intl.message(
      'Edit Phone Number',
      name: 'editPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Edit Location`
  String get editLocation {
    return Intl.message(
      'Edit Location',
      name: 'editLocation',
      desc: '',
      args: [],
    );
  }

  /// `Edit Password`
  String get editPassword {
    return Intl.message(
      'Edit Password',
      name: 'editPassword',
      desc: '',
      args: [],
    );
  }

  /// `Current Password`
  String get currentPassword {
    return Intl.message(
      'Current Password',
      name: 'currentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your current password here`
  String get enterCurrentPassword {
    return Intl.message(
      'Enter your current password here',
      name: 'enterCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Please enter a valid name`
  String get pleaseEnterValidName {
    return Intl.message(
      'Please enter a valid name',
      name: 'pleaseEnterValidName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email`
  String get pleaseEnterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'pleaseEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get pleaseEnterValidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'pleaseEnterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get pleaseEnterPassword {
    return Intl.message(
      'Please enter a password',
      name: 'pleaseEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get pleaseEnterValidNumber {
    return Intl.message(
      'Please enter a valid number',
      name: 'pleaseEnterValidNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid text`
  String get pleaseEnterValidText {
    return Intl.message(
      'Please enter a valid text',
      name: 'pleaseEnterValidText',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message('Arabic', name: 'arabic', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Enter your message here`
  String get enterMessage {
    return Intl.message(
      'Enter your message here',
      name: 'enterMessage',
      desc: '',
      args: [],
    );
  }

  /// `Personal Status`
  String get personal_status {
    return Intl.message(
      'Personal Status',
      name: 'personal_status',
      desc: '',
      args: [],
    );
  }

  /// `Civil`
  String get civil {
    return Intl.message('Civil', name: 'civil', desc: '', args: []);
  }

  /// `Sections`
  String get sections {
    return Intl.message('Sections', name: 'sections', desc: '', args: []);
  }

  /// `My Dose`
  String get myDosage {
    return Intl.message('My Dose', name: 'myDosage', desc: '', args: []);
  }

  /// `Services`
  String get services {
    return Intl.message('Services', name: 'services', desc: '', args: []);
  }

  /// `Search for...`
  String get searchFor {
    return Intl.message('Search for...', name: 'searchFor', desc: '', args: []);
  }

  /// `Welcome Back`
  String get welcomeBack {
    return Intl.message(
      'Welcome Back',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message('Categories', name: 'categories', desc: '', args: []);
  }

  /// `View More`
  String get viewMore {
    return Intl.message('View More', name: 'viewMore', desc: '', args: []);
  }

  /// `Big Discounts 🔥`
  String get bigDiscounts {
    return Intl.message(
      'Big Discounts 🔥',
      name: 'bigDiscounts',
      desc: '',
      args: [],
    );
  }

  /// `Brands`
  String get brands {
    return Intl.message('Brands', name: 'brands', desc: '', args: []);
  }

  /// `Shop By Problem`
  String get shopByProblem {
    return Intl.message(
      'Shop By Problem',
      name: 'shopByProblem',
      desc: '',
      args: [],
    );
  }

  /// `Best Selling Products`
  String get bestSellingProducts {
    return Intl.message(
      'Best Selling Products',
      name: 'bestSellingProducts',
      desc: '',
      args: [],
    );
  }

  /// `newArrival`
  String get newArrival {
    return Intl.message('newArrival', name: 'newArrival', desc: '', args: []);
  }

  /// `Special packages`
  String get specialPackages {
    return Intl.message(
      'Special packages',
      name: 'specialPackages',
      desc: '',
      args: [],
    );
  }

  /// `Available Again`
  String get availableAgain {
    return Intl.message(
      'Available Again',
      name: 'availableAgain',
      desc: '',
      args: [],
    );
  }

  /// `Search history`
  String get searchHistory {
    return Intl.message(
      'Search history',
      name: 'searchHistory',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  }

  /// `Reviews`
  String get reviews {
    return Intl.message('Reviews', name: 'reviews', desc: '', args: []);
  }

  /// `Arrangement`
  String get arrangement {
    return Intl.message('Arrangement', name: 'arrangement', desc: '', args: []);
  }

  /// `Product Details`
  String get productDetails {
    return Intl.message(
      'Product Details',
      name: 'productDetails',
      desc: '',
      args: [],
    );
  }

  /// `Add to Cart`
  String get addToCart {
    return Intl.message('Add to Cart', name: 'addToCart', desc: '', args: []);
  }

  /// `Product not available`
  String get productNotAvailable {
    return Intl.message(
      'Product not available',
      name: 'productNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Product Description`
  String get productDescription {
    return Intl.message(
      'Product Description',
      name: 'productDescription',
      desc: '',
      args: [],
    );
  }

  /// `A item has been added to favorites`
  String get addedToFavorites {
    return Intl.message(
      'A item has been added to favorites',
      name: 'addedToFavorites',
      desc: '',
      args: [],
    );
  }

  /// `A item has been removed from favorites`
  String get removeFromFavorites {
    return Intl.message(
      'A item has been removed from favorites',
      name: 'removeFromFavorites',
      desc: '',
      args: [],
    );
  }

  /// `A item has been added to cart`
  String get addedToCart {
    return Intl.message(
      'A item has been added to cart',
      name: 'addedToCart',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get cart {
    return Intl.message('Cart', name: 'cart', desc: '', args: []);
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Promo Code`
  String get promoCode {
    return Intl.message('Promo Code', name: 'promoCode', desc: '', args: []);
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Your cart is empty`
  String get cartEmpty {
    return Intl.message(
      'Your cart is empty',
      name: 'cartEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Subtotal`
  String get subtotal {
    return Intl.message('Subtotal', name: 'subtotal', desc: '', args: []);
  }

  /// `Shipping`
  String get shipping {
    return Intl.message('Shipping', name: 'shipping', desc: '', args: []);
  }

  /// `Discount`
  String get discount {
    return Intl.message('Discount', name: 'discount', desc: '', args: []);
  }

  /// `Remove from Cart`
  String get removeFromCart {
    return Intl.message(
      'Remove from Cart',
      name: 'removeFromCart',
      desc: '',
      args: [],
    );
  }

  /// `Yes, Remove`
  String get yesRemove {
    return Intl.message('Yes, Remove', name: 'yesRemove', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Suggested for you`
  String get suggestedForYou {
    return Intl.message(
      'Suggested for you',
      name: 'suggestedForYou',
      desc: '',
      args: [],
    );
  }

  /// `My Dose`
  String get myDose {
    return Intl.message('My Dose', name: 'myDose', desc: '', args: []);
  }

  /// `Search for your dose`
  String get searchForYourDose {
    return Intl.message(
      'Search for your dose',
      name: 'searchForYourDose',
      desc: '',
      args: [],
    );
  }

  /// `No medication has been added yet.`
  String get noMedicationHasBeenAddedYet {
    return Intl.message(
      'No medication has been added yet.',
      name: 'noMedicationHasBeenAddedYet',
      desc: '',
      args: [],
    );
  }

  /// `Please add medications and set reminders.`
  String get pleaseAddMedications {
    return Intl.message(
      'Please add medications and set reminders.',
      name: 'pleaseAddMedications',
      desc: '',
      args: [],
    );
  }

  /// `Add a reminder`
  String get addaReminder {
    return Intl.message(
      'Add a reminder',
      name: 'addaReminder',
      desc: '',
      args: [],
    );
  }

  /// `Add a reminder for birth control medication`
  String get addaAeminderForBirthControlMedication {
    return Intl.message(
      'Add a reminder for birth control medication',
      name: 'addaAeminderForBirthControlMedication',
      desc: '',
      args: [],
    );
  }

  /// `Add new medicine`
  String get addNewMedicine {
    return Intl.message(
      'Add new medicine',
      name: 'addNewMedicine',
      desc: '',
      args: [],
    );
  }

  /// `Name of medicine`
  String get nameOfMedicine {
    return Intl.message(
      'Name of medicine',
      name: 'nameOfMedicine',
      desc: '',
      args: [],
    );
  }

  /// `Add photo`
  String get addPhoto {
    return Intl.message('Add photo', name: 'addPhoto', desc: '', args: []);
  }

  /// `Notes*`
  String get notes {
    return Intl.message('Notes*', name: 'notes', desc: '', args: []);
  }

  /// `Add notes`
  String get AddNotes {
    return Intl.message('Add notes', name: 'AddNotes', desc: '', args: []);
  }

  /// `Quantity per time`
  String get quantityPerTime {
    return Intl.message(
      'Quantity per time',
      name: 'quantityPerTime',
      desc: '',
      args: [],
    );
  }

  /// `Medication schedules`
  String get medicationSchedules {
    return Intl.message(
      'Medication schedules',
      name: 'medicationSchedules',
      desc: '',
      args: [],
    );
  }

  /// `+ Add new time`
  String get addNewTime {
    return Intl.message(
      '+ Add new time',
      name: 'addNewTime',
      desc: '',
      args: [],
    );
  }

  /// `Repeat alert`
  String get repeatAlert {
    return Intl.message(
      'Repeat alert',
      name: 'repeatAlert',
      desc: '',
      args: [],
    );
  }

  /// `Delete photo`
  String get deletePhoto {
    return Intl.message(
      'Delete photo',
      name: 'deletePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Select days`
  String get selectDays {
    return Intl.message('Select days', name: 'selectDays', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `A new medicine has been successfully added`
  String get aNewMedicineHasBeenSuccessfullyAdded {
    return Intl.message(
      'A new medicine has been successfully added',
      name: 'aNewMedicineHasBeenSuccessfullyAdded',
      desc: '',
      args: [],
    );
  }

  /// `Calendar`
  String get calendar {
    return Intl.message('Calendar', name: 'calendar', desc: '', args: []);
  }

  /// `Your daily dose`
  String get yourDailyDose {
    return Intl.message(
      'Your daily dose',
      name: 'yourDailyDose',
      desc: '',
      args: [],
    );
  }

  /// `There are no doses for the specified day`
  String get thereAreNoDosesForTheSpecifiedDay {
    return Intl.message(
      'There are no doses for the specified day',
      name: 'thereAreNoDosesForTheSpecifiedDay',
      desc: '',
      args: [],
    );
  }

  /// `Medical Tips`
  String get medicalTips {
    return Intl.message(
      'Medical Tips',
      name: 'medicalTips',
      desc: '',
      args: [],
    );
  }

  /// `Measuring Blood Pressure`
  String get measuringBloodPressure {
    return Intl.message(
      'Measuring Blood Pressure',
      name: 'measuringBloodPressure',
      desc: '',
      args: [],
    );
  }

  /// `Measuring systolic (high) blood pressure`
  String get measuringSystolicBloodPressure {
    return Intl.message(
      'Measuring systolic (high) blood pressure',
      name: 'measuringSystolicBloodPressure',
      desc: '',
      args: [],
    );
  }

  /// `Enter Measurement`
  String get enterMeasurement {
    return Intl.message(
      'Enter Measurement',
      name: 'enterMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Diastolic (low) blood pressure measurement`
  String get diastolicBloodPressureMeasurement {
    return Intl.message(
      'Diastolic (low) blood pressure measurement',
      name: 'diastolicBloodPressureMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Test Case`
  String get testCase {
    return Intl.message('Test Case', name: 'testCase', desc: '', args: []);
  }

  /// `Set the time`
  String get setTheTime {
    return Intl.message('Set the time', name: 'setTheTime', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Upload Pdf Result`
  String get uploadPdf {
    return Intl.message(
      'Upload Pdf Result',
      name: 'uploadPdf',
      desc: '',
      args: [],
    );
  }

  /// `Measuring blood sugar`
  String get measuringBloodSugar {
    return Intl.message(
      'Measuring blood sugar',
      name: 'measuringBloodSugar',
      desc: '',
      args: [],
    );
  }

  /// `Sugar Level`
  String get sugarLevel {
    return Intl.message('Sugar Level', name: 'sugarLevel', desc: '', args: []);
  }

  /// `Ovulation and Period Calculator`
  String get healthMeasure {
    return Intl.message(
      'Ovulation and Period Calculator',
      name: 'healthMeasure',
      desc: '',
      args: [],
    );
  }

  /// `Select the first day of the last menstrual cycle`
  String get dayOfLastMenstrual {
    return Intl.message(
      'Select the first day of the last menstrual cycle',
      name: 'dayOfLastMenstrual',
      desc: '',
      args: [],
    );
  }

  /// `day/month/year`
  String get datePeriods {
    return Intl.message(
      'day/month/year',
      name: 'datePeriods',
      desc: '',
      args: [],
    );
  }

  /// `Duration between cycles`
  String get durationCycles {
    return Intl.message(
      'Duration between cycles',
      name: 'durationCycles',
      desc: '',
      args: [],
    );
  }

  /// `Enter Here`
  String get fill {
    return Intl.message('Enter Here', name: 'fill', desc: '', args: []);
  }

  /// `Calculate`
  String get calc {
    return Intl.message('Calculate', name: 'calc', desc: '', args: []);
  }

  /// `Remaining days`
  String get remainDays {
    return Intl.message(
      'Remaining days',
      name: 'remainDays',
      desc: '',
      args: [],
    );
  }

  /// `Menstruation`
  String get menstruation {
    return Intl.message(
      'Menstruation',
      name: 'menstruation',
      desc: '',
      args: [],
    );
  }

  /// `Menstrual Cycle Phase`
  String get cyclePhase {
    return Intl.message(
      'Menstrual Cycle Phase',
      name: 'cyclePhase',
      desc: '',
      args: [],
    );
  }

  /// `Ovulation`
  String get ovulation {
    return Intl.message('Ovulation', name: 'ovulation', desc: '', args: []);
  }

  /// `Next Fertility`
  String get nextFertility {
    return Intl.message(
      'Next Fertility',
      name: 'nextFertility',
      desc: '',
      args: [],
    );
  }

  /// `Next Menstruation`
  String get nextMenstruation {
    return Intl.message(
      'Next Menstruation',
      name: 'nextMenstruation',
      desc: '',
      args: [],
    );
  }

  /// `Chance Of Pregnancy`
  String get ChanceOfPregnancy {
    return Intl.message(
      'Chance Of Pregnancy',
      name: 'ChanceOfPregnancy',
      desc: '',
      args: [],
    );
  }

  /// `Vaccine Schedule`
  String get vaccineSchedule {
    return Intl.message(
      'Vaccine Schedule',
      name: 'vaccineSchedule',
      desc: '',
      args: [],
    );
  }

  /// `Baby Name`
  String get babyName {
    return Intl.message('Baby Name', name: 'babyName', desc: '', args: []);
  }

  /// `Enter Baby Name`
  String get babyNameEnter {
    return Intl.message(
      'Enter Baby Name',
      name: 'babyNameEnter',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Enter Gender`
  String get enterGender {
    return Intl.message(
      'Enter Gender',
      name: 'enterGender',
      desc: '',
      args: [],
    );
  }

  /// `Date OF Birth`
  String get dob {
    return Intl.message('Date OF Birth', name: 'dob', desc: '', args: []);
  }

  /// `Previous Vaccines`
  String get previousVaccines {
    return Intl.message(
      'Previous Vaccines',
      name: 'previousVaccines',
      desc: '',
      args: [],
    );
  }

  /// `Coming Vaccines`
  String get comingVac {
    return Intl.message(
      'Coming Vaccines',
      name: 'comingVac',
      desc: '',
      args: [],
    );
  }

  /// `Reminder`
  String get reminder {
    return Intl.message('Reminder', name: 'reminder', desc: '', args: []);
  }

  /// `Body Weight Calculator`
  String get bodyWeightCalculator {
    return Intl.message(
      'Body Weight Calculator',
      name: 'bodyWeightCalculator',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Height`
  String get enterHeight {
    return Intl.message(
      'Enter Your Height',
      name: 'enterHeight',
      desc: '',
      args: [],
    );
  }

  /// `Enter Your Weight`
  String get enterWeight {
    return Intl.message(
      'Enter Your Weight',
      name: 'enterWeight',
      desc: '',
      args: [],
    );
  }

  /// `Unit of measure`
  String get unit {
    return Intl.message('Unit of measure', name: 'unit', desc: '', args: []);
  }

  /// `Your Healthy Weight Range`
  String get weightRange {
    return Intl.message(
      'Your Healthy Weight Range',
      name: 'weightRange',
      desc: '',
      args: [],
    );
  }

  /// `Third Degree Obesity`
  String get degreeObesity {
    return Intl.message(
      'Third Degree Obesity',
      name: 'degreeObesity',
      desc: '',
      args: [],
    );
  }

  /// `Your Body Index Score`
  String get bodyIndexScore {
    return Intl.message(
      'Your Body Index Score',
      name: 'bodyIndexScore',
      desc: '',
      args: [],
    );
  }

  /// `The latest sugar measurement`
  String get latestSugarMeasurement {
    return Intl.message(
      'The latest sugar measurement',
      name: 'latestSugarMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Your Entries`
  String get yourEntries {
    return Intl.message(
      'Your Entries',
      name: 'yourEntries',
      desc: '',
      args: [],
    );
  }

  /// `The Latest Blood Pressure Measurement`
  String get latestBloodPressureMeasurement {
    return Intl.message(
      'The Latest Blood Pressure Measurement',
      name: 'latestBloodPressureMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Pregnancy and Childbirth Calculator`
  String get pregnancyAndChildbirthCalculator {
    return Intl.message(
      'Pregnancy and Childbirth Calculator',
      name: 'pregnancyAndChildbirthCalculator',
      desc: '',
      args: [],
    );
  }

  /// `First Day Of The Last Menstrual Cycle`
  String get firstDayOfLastMenstrualCycle {
    return Intl.message(
      'First Day Of The Last Menstrual Cycle',
      name: 'firstDayOfLastMenstrualCycle',
      desc: '',
      args: [],
    );
  }

  /// `Expected Date of Birth`
  String get expectedDOBirth {
    return Intl.message(
      'Expected Date of Birth',
      name: 'expectedDOBirth',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message('Week', name: 'week', desc: '', args: []);
  }

  /// `Fetal Dimensions`
  String get fetalDimensions {
    return Intl.message(
      'Fetal Dimensions',
      name: 'fetalDimensions',
      desc: '',
      args: [],
    );
  }

  /// `Height`
  String get height {
    return Intl.message('Height', name: 'height', desc: '', args: []);
  }

  /// `Volume`
  String get volume {
    return Intl.message('Volume', name: 'volume', desc: '', args: []);
  }

  /// `Kgm`
  String get kgm {
    return Intl.message('Kgm', name: 'kgm', desc: '', args: []);
  }

  /// `Weeks`
  String get weeks {
    return Intl.message('Weeks', name: 'weeks', desc: '', args: []);
  }

  /// `First Third`
  String get firstThird {
    return Intl.message('First Third', name: 'firstThird', desc: '', args: []);
  }

  /// `Second Third`
  String get secondThird {
    return Intl.message(
      'Second Third',
      name: 'secondThird',
      desc: '',
      args: [],
    );
  }

  /// `Third Third`
  String get thirdThird {
    return Intl.message('Third Third', name: 'thirdThird', desc: '', args: []);
  }

  /// `Day`
  String get day {
    return Intl.message('Day', name: 'day', desc: '', args: []);
  }

  /// `Delivery address`
  String get delivery_address {
    return Intl.message(
      'Delivery address',
      name: 'delivery_address',
      desc: '',
      args: [],
    );
  }

  /// `Payment methods`
  String get payment_methods {
    return Intl.message(
      'Payment methods',
      name: 'payment_methods',
      desc: '',
      args: [],
    );
  }

  /// `Cash`
  String get cash {
    return Intl.message('Cash', name: 'cash', desc: '', args: []);
  }

  /// `Visa / Mastercard`
  String get credit_card {
    return Intl.message('Visa / Mastercard', name: 'credit_card', desc: '', args: []);
  }

  /// `Vodafone Cash`
  String get zainCach {
    return Intl.message('Vodafone Cash', name: 'zainCach', desc: '', args: []);
  }

  /// `Order list`
  String get order_list {
    return Intl.message('Order list', name: 'order_list', desc: '', args: []);
  }

  /// `Payment`
  String get payment {
    return Intl.message('Payment', name: 'payment', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Checkout`
  String get checkout {
    return Intl.message('Checkout', name: 'checkout', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `Yes, delete`
  String get yes_delete {
    return Intl.message('Yes, delete', name: 'yes_delete', desc: '', args: []);
  }

  /// `Are you sure you want to delete this address?`
  String get delete_address_confirmation {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'delete_address_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Use as shipping address`
  String get use_as_shipping_address {
    return Intl.message(
      'Use as shipping address',
      name: 'use_as_shipping_address',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message('Change', name: 'change', desc: '', args: []);
  }

  /// `Your order has been successfully placed`
  String get order_success {
    return Intl.message(
      'Your order has been successfully placed',
      name: 'order_success',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been successfully placed and earned 70 bonus points`
  String get order_success_message {
    return Intl.message(
      'Your order has been successfully placed',
      name: 'order_success_message',
      desc: '',
      args: [],
    );
  }

  /// `Track your order or continue shopping`
  String get order_success_message2 {
    return Intl.message(
      'Track your order or continue shopping',
      name: 'order_success_message2',
      desc: '',
      args: [],
    );
  }

  /// `Track your order`
  String get trackYourOrder {
    return Intl.message(
      'Track your order',
      name: 'trackYourOrder',
      desc: '',
      args: [],
    );
  }

  /// `Continue shopping`
  String get continue_shopping {
    return Intl.message(
      'Continue shopping',
      name: 'continue_shopping',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `My Account`
  String get my_account {
    return Intl.message('My Account', name: 'my_account', desc: '', args: []);
  }

  /// `Edit Profile`
  String get edit_profile {
    return Intl.message(
      'Edit Profile',
      name: 'edit_profile',
      desc: '',
      args: [],
    );
  }

  /// `My Addresses`
  String get my_addresses {
    return Intl.message(
      'My Addresses',
      name: 'my_addresses',
      desc: '',
      args: [],
    );
  }

  /// `My Points`
  String get my_points {
    return Intl.message('My Points', name: 'my_points', desc: '', args: []);
  }

  /// `Terms and Conditions`
  String get terms_and_conditions {
    return Intl.message(
      'Terms and Conditions',
      name: 'terms_and_conditions',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacy_policy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacy_policy',
      desc: '',
      args: [],
    );
  }

  /// `Auto Reply`
  String get auto_reply {
    return Intl.message('Auto Reply', name: 'auto_reply', desc: '', args: []);
  }

  /// `Exit App`
  String get exit_app {
    return Intl.message('Exit App', name: 'exit_app', desc: '', args: []);
  }

  /// `Favourite`
  String get favourite {
    return Intl.message('Favourite', name: 'favourite', desc: '', args: []);
  }

  /// `Addresses`
  String get addressesTitle {
    return Intl.message(
      'Addresses',
      name: 'addressesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddressButton {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddressButton',
      desc: '',
      args: [],
    );
  }

  /// `Company`
  String get company {
    return Intl.message('Company', name: 'company', desc: '', args: []);
  }

  /// `Address Details`
  String get addressDetails {
    return Intl.message(
      'Address Details',
      name: 'addressDetails',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this address?`
  String get deleteAddressConfirmation {
    return Intl.message(
      'Are you sure you want to delete this address?',
      name: 'deleteAddressConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Use as Shipping Address`
  String get useAsShippingAddress {
    return Intl.message(
      'Use as Shipping Address',
      name: 'useAsShippingAddress',
      desc: '',
      args: [],
    );
  }

  /// `Edit Address`
  String get editAddress {
    return Intl.message(
      'Edit Address',
      name: 'editAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `Enter Address`
  String get enterAddress {
    return Intl.message(
      'Enter Address',
      name: 'enterAddress',
      desc: '',
      args: [],
    );
  }

  /// `Building Number`
  String get buildingNumber {
    return Intl.message(
      'Building Number',
      name: 'buildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Building Number`
  String get enterBuildingNumber {
    return Intl.message(
      'Enter Building Number',
      name: 'enterBuildingNumber',
      desc: '',
      args: [],
    );
  }

  /// `Apartment Number`
  String get apartmentNumber {
    return Intl.message(
      'Apartment Number',
      name: 'apartmentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Apartment Number`
  String get enterApartmentNumber {
    return Intl.message(
      'Enter Apartment Number',
      name: 'enterApartmentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Floor Number`
  String get floorNumber {
    return Intl.message(
      'Floor Number',
      name: 'floorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter Floor Number`
  String get enterFloorNumber {
    return Intl.message(
      'Enter Floor Number',
      name: 'enterFloorNumber',
      desc: '',
      args: [],
    );
  }

  /// `Address Type`
  String get addressType {
    return Intl.message(
      'Address Type',
      name: 'addressType',
      desc: '',
      args: [],
    );
  }

  /// `Address updated successfully!`
  String get addressUpdatedSuccess {
    return Intl.message(
      'Address updated successfully!',
      name: 'addressUpdatedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Add New Address`
  String get addNewAddress {
    return Intl.message(
      'Add New Address',
      name: 'addNewAddress',
      desc: '',
      args: [],
    );
  }

  /// `Address added successfully!`
  String get addressAddedSuccess {
    return Intl.message(
      'Address added successfully!',
      name: 'addressAddedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get homeAddress {
    return Intl.message('Home', name: 'homeAddress', desc: '', args: []);
  }

  /// `Work`
  String get workAddress {
    return Intl.message('Work', name: 'workAddress', desc: '', args: []);
  }

  /// `Government`
  String get government {
    return Intl.message('Government', name: 'government', desc: '', args: []);
  }

  /// `Enter the site here`
  String get enterTheSiteHere {
    return Intl.message(
      'Enter the site here',
      name: 'enterTheSiteHere',
      desc: '',
      args: [],
    );
  }

  /// `Delivery cost`
  String get deliveryCost {
    return Intl.message(
      'Delivery cost',
      name: 'deliveryCost',
      desc: '',
      args: [],
    );
  }

  /// `Map`
  String get map {
    return Intl.message('Map', name: 'map', desc: '', args: []);
  }

  /// `My Orders`
  String get myOrders {
    return Intl.message('My Orders', name: 'myOrders', desc: '', args: []);
  }

  /// `Cancelled`
  String get cancelled {
    return Intl.message('Cancelled', name: 'cancelled', desc: '', args: []);
  }

  /// `Previous`
  String get previous {
    return Intl.message('Previous', name: 'previous', desc: '', args: []);
  }

  /// `Current`
  String get orders_current {
    return Intl.message('Current', name: 'orders_current', desc: '', args: []);
  }

  /// `Order Number`
  String get orderNumber {
    return Intl.message(
      'Order Number',
      name: 'orderNumber',
      desc: '',
      args: [],
    );
  }

  /// `ID Number`
  String get idNumber {
    return Intl.message('ID Number', name: 'idNumber', desc: '', args: []);
  }

  /// `Quantity`
  String get quantity {
    return Intl.message('Quantity', name: 'quantity', desc: '', args: []);
  }

  /// `Total Price`
  String get totalPrice {
    return Intl.message('Total Price', name: 'totalPrice', desc: '', args: []);
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Delivered`
  String get delivered {
    return Intl.message('Delivered', name: 'delivered', desc: '', args: []);
  }

  /// `Details`
  String get detailss {
    return Intl.message('Details', name: 'detailss', desc: '', args: []);
  }

  /// `Active`
  String get active {
    return Intl.message('Active', name: 'active', desc: '', args: []);
  }

  /// `My Points`
  String get myPoints {
    return Intl.message('My Points', name: 'myPoints', desc: '', args: []);
  }

  /// `Achieved`
  String get achieved {
    return Intl.message('Achieved', name: 'achieved', desc: '', args: []);
  }

  /// `Terminated`
  String get terminated {
    return Intl.message('Terminated', name: 'terminated', desc: '', args: []);
  }

  /// `Expires in`
  String get expiresIn {
    return Intl.message('Expires in', name: 'expiresIn', desc: '', args: []);
  }

  /// `Before Eating`
  String get beforeEating {
    return Intl.message(
      'Before Eating',
      name: 'beforeEating',
      desc: '',
      args: [],
    );
  }

  /// `After Eating`
  String get afterEating {
    return Intl.message(
      'After Eating',
      name: 'afterEating',
      desc: '',
      args: [],
    );
  }

  /// `Before BreakFast`
  String get beforeBreakFast {
    return Intl.message(
      'Before BreakFast',
      name: 'beforeBreakFast',
      desc: '',
      args: [],
    );
  }

  /// `After BreakFast`
  String get afterBreakFast {
    return Intl.message(
      'After BreakFast',
      name: 'afterBreakFast',
      desc: '',
      args: [],
    );
  }

  /// `Before Lunch`
  String get beforeLunch {
    return Intl.message(
      'Before Lunch',
      name: 'beforeLunch',
      desc: '',
      args: [],
    );
  }

  /// `After Lunch`
  String get afterLunch {
    return Intl.message('After Lunch', name: 'afterLunch', desc: '', args: []);
  }

  /// `Before Dinner`
  String get beforeDinner {
    return Intl.message(
      'Before Dinner',
      name: 'beforeDinner',
      desc: '',
      args: [],
    );
  }

  /// `After Dinner`
  String get afterDinner {
    return Intl.message(
      'After Dinner',
      name: 'afterDinner',
      desc: '',
      args: [],
    );
  }

  /// `Edit Personal Information`
  String get editPersonalInfo {
    return Intl.message(
      'Edit Personal Information',
      name: 'editPersonalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Personal Documents`
  String get personalDocuments {
    return Intl.message(
      'Personal Documents',
      name: 'personalDocuments',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been submitted successfully. We will get back to you as soon as possible`
  String get successMessage {
    return Intl.message(
      'Your request has been submitted successfully. We will get back to you as soon as possible',
      name: 'successMessage',
      desc: '',
      args: [],
    );
  }

  /// `National ID Card`
  String get national_id_card {
    return Intl.message(
      'National ID Card',
      name: 'national_id_card',
      desc: '',
      args: [],
    );
  }

  /// `Driver's License`
  String get personal_driver_license {
    return Intl.message(
      'Driver\'s License',
      name: 'personal_driver_license',
      desc: '',
      args: [],
    );
  }

  /// `Transport Vehicle License`
  String get vehicle_license {
    return Intl.message(
      'Transport Vehicle License',
      name: 'vehicle_license',
      desc: '',
      args: [],
    );
  }

  /// `Click to view`
  String get clickToView {
    return Intl.message(
      'Click to view',
      name: 'clickToView',
      desc: '',
      args: [],
    );
  }

  /// `Order Details`
  String get orderDetails {
    return Intl.message(
      'Order Details',
      name: 'orderDetails',
      desc: '',
      args: [],
    );
  }

  /// `Shipment Details`
  String get shipmentDetails {
    return Intl.message(
      'Shipment Details',
      name: 'shipmentDetails',
      desc: '',
      args: [],
    );
  }

  /// `Pickup Location`
  String get pickupLocation {
    return Intl.message(
      'Pickup Location',
      name: 'pickupLocation',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Location`
  String get deliveryLocation {
    return Intl.message(
      'Delivery Location',
      name: 'deliveryLocation',
      desc: '',
      args: [],
    );
  }

  /// `Item`
  String get item {
    return Intl.message('Item', name: 'item', desc: '', args: []);
  }

  /// `Weight`
  String get weight {
    return Intl.message('Weight', name: 'weight', desc: '', args: []);
  }

  /// `Recipient`
  String get recipient {
    return Intl.message('Recipient', name: 'recipient', desc: '', args: []);
  }

  /// `Recipient Phone`
  String get recipientPhone {
    return Intl.message(
      'Recipient Phone',
      name: 'recipientPhone',
      desc: '',
      args: [],
    );
  }

  /// `Payment Method`
  String get paymentMethod {
    return Intl.message(
      'Payment Method',
      name: 'paymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Fees`
  String get fees {
    return Intl.message('Fees', name: 'fees', desc: '', args: []);
  }

  /// `View Map Route`
  String get viewMapRoute {
    return Intl.message(
      'View Map Route',
      name: 'viewMapRoute',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Process`
  String get delivery_process_title {
    return Intl.message(
      'Delivery Process',
      name: 'delivery_process_title',
      desc: '',
      args: [],
    );
  }

  /// `Upload a photo as proof of delivery`
  String get upload_proof {
    return Intl.message(
      'Upload a photo as proof of delivery',
      name: 'upload_proof',
      desc: '',
      args: [],
    );
  }

  /// `Upload Photo`
  String get upload {
    return Intl.message('Upload Photo', name: 'upload', desc: '', args: []);
  }

  /// `Complete`
  String get complete {
    return Intl.message('Complete', name: 'complete', desc: '', args: []);
  }

  /// `Before`
  String get before {
    return Intl.message('Before', name: 'before', desc: '', args: []);
  }

  /// `After`
  String get after {
    return Intl.message('After', name: 'after', desc: '', args: []);
  }

  /// `Minutes`
  String get minutes {
    return Intl.message('Minutes', name: 'minutes', desc: '', args: []);
  }

  /// `Hours`
  String get hours {
    return Intl.message('Hours', name: 'hours', desc: '', args: []);
  }

  /// `Return Policy`
  String get returnPolicy {
    return Intl.message(
      'Return Policy',
      name: 'returnPolicy',
      desc: '',
      args: [],
    );
  }

  /// `cancellation Policy`
  String get cancellation_policy {
    return Intl.message(
      'cancellation Policy',
      name: 'cancellation_policy',
      desc: '',
      args: [],
    );
  }

  /// `Unprocessable entity. Please check your input.`
  String get unProcessableEntity {
    return Intl.message(
      'Unprocessable entity. Please check your input.',
      name: 'unProcessableEntity',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get delete_account {
    return Intl.message(
      'Delete Account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete your account?`
  String get confirm_delete_account {
    return Intl.message(
      'Are you sure you want to delete your account?',
      name: 'confirm_delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Please Select Address`
  String get please_select_address {
    return Intl.message(
      'Please Select Address',
      name: 'please_select_address',
      desc: '',
      args: [],
    );
  }

  /// `Please select one product to review`
  String get please_select_one_product {
    return Intl.message(
      'Please select one product to review',
      name: 'please_select_one_product',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one product to refund`
  String get please_select_one_product_to_refund {
    return Intl.message(
      'Please select at least one product to refund',
      name: 'please_select_one_product_to_refund',
      desc: '',
      args: [],
    );
  }

  /// `Not shipped yet`
  String get notShippedYet {
    return Intl.message(
      'Not shipped yet',
      name: 'notShippedYet',
      desc: '',
      args: [],
    );
  }

  /// `Less Rated`
  String get less_rated {
    return Intl.message('Less Rated', name: 'less_rated', desc: '', args: []);
  }

  /// `Latest`
  String get latest {
    return Intl.message('Latest', name: 'latest', desc: '', args: []);
  }

  /// `Just Now`
  String get justNow {
    return Intl.message('Just Now', name: 'justNow', desc: '', args: []);
  }

  /// `Pharmacies`
  String get pharmacies {
    return Intl.message('Pharmacies', name: 'pharmacies', desc: '', args: []);
  }

  /// `Add Reminder`
  String get add_reminder {
    return Intl.message(
      'Add Reminder',
      name: 'add_reminder',
      desc: '',
      args: [],
    );
  }

  /// `Ahmed Maher Pharmacy`
  String get ahmedMaherPharmacy {
    return Intl.message(
      'Ahmed Maher Pharmacy',
      name: 'ahmedMaherPharmacy',
      desc: '',
      args: [],
    );
  }

  /// `123 Tahrir Street, Mohandessin, Cairo`
  String get ahmedMaherPharmacyAddress {
    return Intl.message(
      '123 Tahrir Street, Mohandessin, Cairo',
      name: 'ahmedMaherPharmacyAddress',
      desc: '',
      args: [],
    );
  }

  /// `Prescriptions`
  String get prescriptions {
    return Intl.message(
      'Prescriptions',
      name: 'prescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Please Select a Reason`
  String get please_select_reason {
    return Intl.message(
      'Please Select a Reason',
      name: 'please_select_reason',
      desc: '',
      args: [],
    );
  }

  /// `Already applied for refund request!`
  String get alreadyExist {
    return Intl.message(
      'Already applied for refund request!',
      name: 'alreadyExist',
      desc: '',
      args: [],
    );
  }

  String get EmailAlreadyExist {
    return Intl.message(
      'Already applied for EmailAlreadyExist!',
      name: 'EmailAlreadyExist',
      desc: '',
      args: [],
    );
  }

  /// `Your pharmacy in your pocket`
  String get yourPharmacyInYourPocket {
    return Intl.message(
      'Your pharmacy in your pocket',
      name: 'yourPharmacyInYourPocket',
      desc: '',
      args: [],
    );
  }

  String get takeFromPharamcy {
    return Intl.message(
      'Your pharmacy in takeFromPharamcy',
      name: 'takeFromPharamcy',
      desc: '',
      args: [],
    );
  }

  /// `Browse medicines, alternatives, and supplements with detailed information.`
  String get browseMedicinesSupplements {
    return Intl.message(
      'Browse medicines, alternatives, and supplements with detailed information.',
      name: 'browseMedicinesSupplements',
      desc: '',
      args: [],
    );
  }

  /// `Continuous health support`
  String get continuousHealthSupport {
    return Intl.message(
      'Continuous health support',
      name: 'continuousHealthSupport',
      desc: '',
      args: [],
    );
  }

  /// `Quick consultations with pharmacists and reminders for medication schedules.`
  String get quickPharmacistConsultations {
    return Intl.message(
      'Quick consultations with pharmacists and reminders for medication schedules.',
      name: 'quickPharmacistConsultations',
      desc: '',
      args: [],
    );
  }

  /// `Easier prescriptions`
  String get easierPrescriptions {
    return Intl.message(
      'Easier prescriptions',
      name: 'easierPrescriptions',
      desc: '',
      args: [],
    );
  }

  /// `Order medicines with or without a prescription directly from the app and receive them at your doorstep.`
  String get orderMedicinesWithOrWithoutPrescription {
    return Intl.message(
      'Order medicines with or without a prescription directly from the app and receive them at your doorstep.',
      name: 'orderMedicinesWithOrWithoutPrescription',
      desc: '',
      args: [],
    );
  }

  /// `Quantity Per Dose`
  String get quantityPerDose {
    return Intl.message(
      'Quantity Per Dose',
      name: 'quantityPerDose',
      desc: '',
      args: [],
    );
  }

  /// `Medication Schedule`
  String get medicationSchedule {
    return Intl.message(
      'Medication Schedule',
      name: 'medicationSchedule',
      desc: '',
      args: [],
    );
  }

  /// `One-Time Reminder`
  String get oneTimeReminder {
    return Intl.message(
      'One-Time Reminder',
      name: 'oneTimeReminder',
      desc: '',
      args: [],
    );
  }

  /// `Every Day`
  String get everyDay {
    return Intl.message('Every Day', name: 'everyDay', desc: '', args: []);
  }

  /// `Find Your Does`
  String get find_yourDoes {
    return Intl.message(
      'Find Your Does',
      name: 'find_yourDoes',
      desc: '',
      args: [],
    );
  }

  /// `No medicine has been added yet`
  String get no_medicine_yet {
    return Intl.message(
      'No medicine has been added yet',
      name: 'no_medicine_yet',
      desc: '',
      args: [],
    );
  }

  /// `Please add medications and set reminders`
  String get add_medicine_and_reminder {
    return Intl.message(
      'Please add medications and set reminders',
      name: 'add_medicine_and_reminder',
      desc: '',
      args: [],
    );
  }

  /// `Name(example:Ibuprofen)`
  String get nameOf_medicineReminder {
    return Intl.message(
      'Name(example:Ibuprofen)',
      name: 'nameOf_medicineReminder',
      desc: '',
      args: [],
    );
  }

  /// `Add Image`
  String get addImage {
    return Intl.message('Add Image', name: 'addImage', desc: '', args: []);
  }

  /// `Treatment and reliever for headaches`
  String get notesHint {
    return Intl.message(
      'Treatment and reliever for headaches',
      name: 'notesHint',
      desc: '',
      args: [],
    );
  }

  /// `Add A New Time`
  String get add_new_time {
    return Intl.message(
      'Add A New Time',
      name: 'add_new_time',
      desc: '',
      args: [],
    );
  }

  /// `Specific Days`
  String get specific_days {
    return Intl.message(
      'Specific Days',
      name: 'specific_days',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Reminder`
  String get repeat {
    return Intl.message('Repeat Reminder', name: 'repeat', desc: '', args: []);
  }

  /// `Saturday`
  String get saturday {
    return Intl.message('Saturday', name: 'saturday', desc: '', args: []);
  }

  /// `Sunday`
  String get sunday {
    return Intl.message('Sunday', name: 'sunday', desc: '', args: []);
  }

  /// `Monday`
  String get monday {
    return Intl.message('Monday', name: 'monday', desc: '', args: []);
  }

  /// `Tuesday`
  String get tuesday {
    return Intl.message('Tuesday', name: 'tuesday', desc: '', args: []);
  }

  /// `Wednesday`
  String get wednesday {
    return Intl.message('Wednesday', name: 'wednesday', desc: '', args: []);
  }

  /// `Thursday`
  String get thursday {
    return Intl.message('Thursday', name: 'thursday', desc: '', args: []);
  }

  /// `Friday`
  String get friday {
    return Intl.message('Friday', name: 'friday', desc: '', args: []);
  }

  /// `Remove Image`
  String get removeImage {
    return Intl.message(
      'Remove Image',
      name: 'removeImage',
      desc: '',
      args: [],
    );
  }

  /// `Medicine Added Successfully`
  String get medicine_added {
    return Intl.message(
      'Medicine Added Successfully',
      name: 'medicine_added',
      desc: '',
      args: [],
    );
  }

  /// `Table`
  String get table {
    return Intl.message('Table', name: 'table', desc: '', args: []);
  }

  /// `Your Daily Does`
  String get daily_does {
    return Intl.message(
      'Your Daily Does',
      name: 'daily_does',
      desc: '',
      args: [],
    );
  }

  /// `My Points`
  String get points {
    return Intl.message('My Points', name: 'points', desc: '', args: []);
  }

  /// `Ask Doctor`
  String get askDoctor {
    return Intl.message('Ask Doctor', name: 'askDoctor', desc: '', args: []);
  }

  /// `Point`
  String get point {
    return Intl.message('Point', name: 'point', desc: '', args: []);
  }

  /// `80 Point Expires in 3 Feb , 2025`
  String get amountOfPoints {
    return Intl.message(
      '80 Point Expires in 3 Feb , 2025',
      name: 'amountOfPoints',
      desc: '',
      args: [],
    );
  }

  /// `Earned`
  String get earned {
    return Intl.message('Earned', name: 'earned', desc: '', args: []);
  }

  /// `Used`
  String get used {
    return Intl.message('Used', name: 'used', desc: '', args: []);
  }

  /// `Expired`
  String get expired {
    return Intl.message('Expired', name: 'expired', desc: '', args: []);
  }

  /// `Enter new password here`
  String get enterTheNewPasswordHere {
    return Intl.message(
      'Enter new password here',
      name: 'enterTheNewPasswordHere',
      desc: '',
      args: [],
    );
  }

  /// `Accepted`
  String get accepted {
    return Intl.message('Accepted', name: 'accepted', desc: '', args: []);
  }

  /// `Refused`
  String get refused {
    return Intl.message('Refused', name: 'refused', desc: '', args: []);
  }

  /// `Old Password`
  String get oldPass {
    return Intl.message('Old Password', name: 'oldPass', desc: '', args: []);
  }

  /// `New Password`
  String get newPass {
    return Intl.message('New Password', name: 'newPass', desc: '', args: []);
  }

  /// `Confirm New Password`
  String get ConfirmNewPass {
    return Intl.message(
      'Confirm New Password',
      name: 'ConfirmNewPass',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currentNow {
    return Intl.message('Current', name: 'currentNow', desc: '', args: []);
  }

  /// `Previous`
  String get past {
    return Intl.message('Previous', name: 'past', desc: '', args: []);
  }

  /// `EGP`
  String get currency {
    return Intl.message('EGP', name: 'currency', desc: '', args: []);
  }

  /// `Count`
  String get count {
    return Intl.message('Count', name: 'count', desc: '', args: []);
  }

  /// `Work`
  String get work {
    return Intl.message('Work', name: 'work', desc: '', args: []);
  }

  /// `Home`
  String get home_address {
    return Intl.message('Home', name: 'home_address', desc: '', args: []);
  }

  /// `Your new address has been added successfully`
  String get address_added_success {
    return Intl.message(
      'Your new address has been added successfully',
      name: 'address_added_success',
      desc: '',
      args: [],
    );
  }

  /// `Edit Address`
  String get edit_address {
    return Intl.message(
      'Edit Address',
      name: 'edit_address',
      desc: '',
      args: [],
    );
  }

  /// `Your address has been edited successfully`
  String get address_edited_success {
    return Intl.message(
      'Your address has been edited successfully',
      name: 'address_edited_success',
      desc: '',
      args: [],
    );
  }

  /// `Add New Card`
  String get add_new_card {
    return Intl.message(
      'Add New Card',
      name: 'add_new_card',
      desc: '',
      args: [],
    );
  }

  /// `Cardholder Name`
  String get cardholder_name {
    return Intl.message(
      'Cardholder Name',
      name: 'cardholder_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter cardholder name here`
  String get enter_cardholder_name {
    return Intl.message(
      'Enter cardholder name here',
      name: 'enter_cardholder_name',
      desc: '',
      args: [],
    );
  }

  /// `Card Number`
  String get card_number {
    return Intl.message('Card Number', name: 'card_number', desc: '', args: []);
  }

  /// `Enter card number here`
  String get enter_card_number {
    return Intl.message(
      'Enter card number here',
      name: 'enter_card_number',
      desc: '',
      args: [],
    );
  }

  /// `Expiry Date`
  String get expiry_date {
    return Intl.message('Expiry Date', name: 'expiry_date', desc: '', args: []);
  }

  /// `CVV`
  String get cvv {
    return Intl.message('CVV', name: 'cvv', desc: '', args: []);
  }

  /// `Your new card has been added successfully`
  String get card_added_success {
    return Intl.message(
      'Your new card has been added successfully',
      name: 'card_added_success',
      desc: '',
      args: [],
    );
  }

  /// `My Orders`
  String get my_orders {
    return Intl.message('My Orders', name: 'my_orders', desc: '', args: []);
  }

  /// `Delivery`
  String get delivery {
    return Intl.message('Delivery', name: 'delivery', desc: '', args: []);
  }

  /// `Order Number`
  String get order_number {
    return Intl.message(
      'Order Number',
      name: 'order_number',
      desc: '',
      args: [],
    );
  }

  /// `Order Number`
  String get cuponApplied {
    return Intl.message(
      'cuponApplied',
      name: 'cuponApplied',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get cuponExpired {
    return Intl.message(
      'cuponExpired',
      name: 'cuponExpired',
      desc: '',
      args: [],
    );
  }

  String get couponRemoved {
    return Intl.message(
      'cuponApplied',
      name: 'couponRemoved',
      desc: '',
      args: [],
    );
  }

  String get cartEmptySubtitle {
    return Intl.message(
      'cartEmptySubtitle',
      name: 'cartEmptySubtitle',
      desc: '',
      args: [],
    );
  }

  String get startShopping {
    return Intl.message(
      'startShopping',
      name: 'startShopping',
      desc: '',
      args: [],
    );
  }

  String get confirmOrder {
    return Intl.message(
      'confirmOrder',
      name: 'confirmOrder',
      desc: '',
      args: [],
    );
  }

  String get noOrder {
    return Intl.message('noOrder', name: 'noOrder', desc: '', args: []);
  }

  String get paymentTool {
    return Intl.message('paymentTool', name: 'paymentTool', desc: '', args: []);
  }

  String get numberTransfer {
    return Intl.message(
      'numberTransfer',
      name: 'numberTransfer',
      desc: '',
      args: [],
    );
  }

  /// `Order Date`
  String get remove {
    return Intl.message('remove', name: 'remove', desc: '', args: []);
  }

  /// `Order Date`
  String get order_date {
    return Intl.message('Order Date', name: 'order_date', desc: '', args: []);
  }

  /// `Order ID`
  String get order_id {
    return Intl.message('Order ID', name: 'order_id', desc: '', args: []);
  }

  /// `Total Price`
  String get total_price {
    return Intl.message('Total Price', name: 'total_price', desc: '', args: []);
  }

  /// `Order Details`
  String get order_details {
    return Intl.message(
      'Order Details',
      name: 'order_details',
      desc: '',
      args: [],
    );
  }

  /// `Leave a Review`
  String get leave_review {
    return Intl.message(
      'Leave a Review',
      name: 'leave_review',
      desc: '',
      args: [],
    );
  }

  /// `Return Product`
  String get return_product {
    return Intl.message(
      'Return Product',
      name: 'return_product',
      desc: '',
      args: [],
    );
  }

  /// `Reorder`
  String get reorder {
    return Intl.message('Reorder', name: 'reorder', desc: '', args: []);
  }

  /// `Ordered`
  String get ordered {
    return Intl.message('Ordered', name: 'ordered', desc: '', args: []);
  }

  /// `In Progress`
  String get in_progress {
    return Intl.message('In Progress', name: 'in_progress', desc: '', args: []);
  }

  /// `Shipped`
  String get shipped {
    return Intl.message('Shipped', name: 'shipped', desc: '', args: []);
  }

  /// `Your review matters`
  String get your_review_matters {
    return Intl.message(
      'Your review matters',
      name: 'your_review_matters',
      desc: '',
      args: [],
    );
  }

  /// `How was your order?`
  String get how_was_your_order {
    return Intl.message(
      'How was your order?',
      name: 'how_was_your_order',
      desc: '',
      args: [],
    );
  }

  /// `Please give your rating and opinion.`
  String get please_give_your_rating {
    return Intl.message(
      'Please give your rating and opinion.',
      name: 'please_give_your_rating',
      desc: '',
      args: [],
    );
  }

  /// `Write your comment here...`
  String get write_your_comment_here {
    return Intl.message(
      'Write your comment here...',
      name: 'write_your_comment_here',
      desc: '',
      args: [],
    );
  }

  /// `Upload image here`
  String get upload_image_here {
    return Intl.message(
      'Upload image here',
      name: 'upload_image_here',
      desc: '',
      args: [],
    );
  }

  /// `Product Details`
  String get product_details {
    return Intl.message(
      'Product Details',
      name: 'product_details',
      desc: '',
      args: [],
    );
  }

  /// `Return Order ID:`
  String get return_order_id {
    return Intl.message(
      'Return Order ID:',
      name: 'return_order_id',
      desc: '',
      args: [],
    );
  }

  /// `Return Order Date:`
  String get return_order_date {
    return Intl.message(
      'Return Order Date:',
      name: 'return_order_date',
      desc: '',
      args: [],
    );
  }

  /// `Return Reason`
  String get return_reason {
    return Intl.message(
      'Return Reason',
      name: 'return_reason',
      desc: '',
      args: [],
    );
  }

  /// `Product not as described`
  String get product_not_as_described {
    return Intl.message(
      'Product not as described',
      name: 'product_not_as_described',
      desc: '',
      args: [],
    );
  }

  /// `Unsatisfied with quality`
  String get unsatisfied_with_quality {
    return Intl.message(
      'Unsatisfied with quality',
      name: 'unsatisfied_with_quality',
      desc: '',
      args: [],
    );
  }

  /// `Product not suitable`
  String get product_not_suitable {
    return Intl.message(
      'Product not suitable',
      name: 'product_not_suitable',
      desc: '',
      args: [],
    );
  }

  /// `Received wrong product`
  String get received_wrong_product {
    return Intl.message(
      'Received wrong product',
      name: 'received_wrong_product',
      desc: '',
      args: [],
    );
  }

  /// `Change of mind`
  String get change_of_mind {
    return Intl.message(
      'Change of mind',
      name: 'change_of_mind',
      desc: '',
      args: [],
    );
  }

  /// `I recently purchased this shirt and unfortunately, it wasn't what I expected. The material was low quality and itchy. The design looked different from the pictures, and the colors were dull.`
  String get review_comment {
    return Intl.message(
      'I recently purchased this shirt and unfortunately, it wasn\'t what I expected. The material was low quality and itchy. The design looked different from the pictures, and the colors were dull.',
      name: 'review_comment',
      desc: '',
      args: [],
    );
  }

  /// `Submit Request`
  String get submit_request {
    return Intl.message(
      'Submit Request',
      name: 'submit_request',
      desc: '',
      args: [],
    );
  }

  /// `Refund Amount`
  String get refund_amount {
    return Intl.message(
      'Refund Amount',
      name: 'refund_amount',
      desc: '',
      args: [],
    );
  }

  /// `Your request has been submitted successfully. We will respond to you as soon as possible.`
  String get request_submitted_success {
    return Intl.message(
      'Your request has been submitted successfully. We will respond to you as soon as possible.',
      name: 'request_submitted_success',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Create Account or Sign In`
  String get create_account_or_sign_in {
    return Intl.message(
      'Create Account or Sign In',
      name: 'create_account_or_sign_in',
      desc: '',
      args: [],
    );
  }

  /// `Features`
  String get features {
    return Intl.message('Features', name: 'features', desc: '', args: []);
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message('Contact Us', name: 'contact_us', desc: '', args: []);
  }

  /// `About Pateient App`
  String get about_Pateient_app {
    return Intl.message(
      'About Pateient App',
      name: 'about_Pateient_app',
      desc: '',
      args: [],
    );
  }

  /// `Welcome! Ahmed Hassan 👋`
  String get welcome_message {
    return Intl.message(
      'Welcome! Ahmed Hassan 👋',
      name: 'welcome_message',
      desc: '',
      args: [],
    );
  }

  /// `Review your account details and order updates here`
  String get account_details {
    return Intl.message(
      'Review your account details and order updates here',
      name: 'account_details',
      desc: '',
      args: [],
    );
  }

  /// `Returns`
  String get returns {
    return Intl.message('Returns', name: 'returns', desc: '', args: []);
  }

  /// `Edit Personal Information`
  String get edit_personal_information {
    return Intl.message(
      'Edit Personal Information',
      name: 'edit_personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Your Addresses`
  String get your_addresses {
    return Intl.message(
      'Your Addresses',
      name: 'your_addresses',
      desc: '',
      args: [],
    );
  }

  /// `Your Payment Methods`
  String get your_payment_methods {
    return Intl.message(
      'Your Payment Methods',
      name: 'your_payment_methods',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get sign_out {
    return Intl.message('Sign Out', name: 'sign_out', desc: '', args: []);
  }

  /// `Approved`
  String get approved {
    return Intl.message('Approved', name: 'approved', desc: '', args: []);
  }

  /// `Rejected`
  String get rejected {
    return Intl.message('Rejected', name: 'rejected', desc: '', args: []);
  }

  /// `Personal Information`
  String get personal_information {
    return Intl.message(
      'Personal Information',
      name: 'personal_information',
      desc: '',
      args: [],
    );
  }

  /// `Add Payment Method`
  String get add_payment_method {
    return Intl.message(
      'Add Payment Method',
      name: 'add_payment_method',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to sign out of the app?`
  String get confirm_sign_out {
    return Intl.message(
      'Do you want to sign out of the app?',
      name: 'confirm_sign_out',
      desc: '',
      args: [],
    );
  }

  /// `6 October, Second District, Third Neighborhood, Building 516`
  String get october_address {
    return Intl.message(
      '6 October, Second District, Third Neighborhood, Building 516',
      name: 'october_address',
      desc: '',
      args: [],
    );
  }

  /// `items`
  String get items {
    return Intl.message('items', name: 'items', desc: '', args: []);
  }

  /// `cancel Order`
  String get cancel_order {
    return Intl.message(
      'cancel Order',
      name: 'cancel_order',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Pictures`
  String get pictures {
    return Intl.message('Pictures', name: 'pictures', desc: '', args: []);
  }

  /// `Order Placed`
  String get order_placed {
    return Intl.message(
      'Order Placed',
      name: 'order_placed',
      desc: '',
      args: [],
    );
  }

  /// `Enter your name here`
  String get enter_name_here {
    return Intl.message(
      'Enter your name here',
      name: 'enter_name_here',
      desc: '',
      args: [],
    );
  }

  /// `Write your message here`
  String get write_your_message_here {
    return Intl.message(
      'Write your message here',
      name: 'write_your_message_here',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid name`
  String get enterValidName {
    return Intl.message(
      'Please enter a valid name',
      name: 'enterValidName',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid phone number`
  String get enterValidPhoneNumber {
    return Intl.message(
      'Please enter a valid phone number',
      name: 'enterValidPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email address`
  String get enterValidEmailAddress {
    return Intl.message(
      'Please enter a valid email address',
      name: 'enterValidEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid password`
  String get enterValidPassword {
    return Intl.message(
      'Please enter a valid password',
      name: 'enterValidPassword',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 8 characters`
  String get enterPasswordAtLeast8Characters {
    return Intl.message(
      'Password must be at least 8 characters',
      name: 'enterPasswordAtLeast8Characters',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid address`
  String get validateAddress {
    return Intl.message(
      'Please enter a valid address',
      name: 'validateAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid number`
  String get validateNumber {
    return Intl.message(
      'Please enter a valid number',
      name: 'validateNumber',
      desc: '',
      args: [],
    );
  }

  /// `This field is required`
  String get validateText {
    return Intl.message(
      'This field is required',
      name: 'validateText',
      desc: '',
      args: [],
    );
  }

  /// `Unauthorized. Incorrect Phone Number or Password.`
  String get unauthorized {
    return Intl.message(
      'Unauthorized. Incorrect Phone Number or Password.',
      name: 'unauthorized',
      desc: '',
      args: [],
    );
  }

  /// `Bad request. Please check your input.`
  String get badRequest {
    return Intl.message(
      'Bad request. Please check your input.',
      name: 'badRequest',
      desc: '',
      args: [],
    );
  }

  /// `Server error. Please try again later.`
  String get serverError {
    return Intl.message(
      'Server error. Please try again later.',
      name: 'serverError',
      desc: '',
      args: [],
    );
  }

  /// `Network error. Check your internet connection.`
  String get networkError {
    return Intl.message(
      'Network error. Check your internet connection.',
      name: 'networkError',
      desc: '',
      args: [],
    );
  }

  /// `An unexpected error occurred. Please try again later.`
  String get unexpectedError {
    return Intl.message(
      'An unexpected error occurred. Please try again later.',
      name: 'unexpectedError',
      desc: '',
      args: [],
    );
  }

  /// ` The item is already added`
  String get conflict {
    return Intl.message(
      ' The item is already added',
      name: 'conflict',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found.`
  String get notFound {
    return Intl.message(
      'Resource not found.',
      name: 'notFound',
      desc: '',
      args: [],
    );
  }

  /// `Resource not found.`
  String get notFoundCat {
    return Intl.message(
      'Resource notFoundCat',
      name: 'notFoundCat',
      desc: '',
      args: [],
    );
  }

  /// `Phone number already exists`
  String get phoneNumberExists {
    return Intl.message(
      'Phone number already exists',
      name: 'phoneNumberExists',
      desc: '',
      args: [],
    );
  }

  /// `There are no items`
  String get thereAreNoItems {
    return Intl.message(
      'There are no items',
      name: 'thereAreNoItems',
      desc: '',
      args: [],
    );
  }

  /// `All Products`
  String get all_products {
    return Intl.message(
      'All Products',
      name: 'all_products',
      desc: '',
      args: [],
    );
  }

  /// `Visa`
  String get visa {
    return Intl.message('Visa', name: 'visa', desc: '', args: []);
  }

  /// `Installments`
  String get installments {
    return Intl.message(
      'Installments',
      name: 'installments',
      desc: '',
      args: [],
    );
  }

  /// `Complete Purchase`
  String get complete_purchase {
    return Intl.message(
      'Complete Purchase',
      name: 'complete_purchase',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been placed successfully`
  String get order_placed_success {
    return Intl.message(
      'Your order has been placed successfully',
      name: 'order_placed_success',
      desc: '',
      args: [],
    );
  }

  /// `Track Order`
  String get track_order {
    return Intl.message('Track Order', name: 'track_order', desc: '', args: []);
  }

  /// `Add New Address`
  String get add_new_address {
    return Intl.message(
      'Add New Address',
      name: 'add_new_address',
      desc: '',
      args: [],
    );
  }

  /// `Add Address`
  String get add_address {
    return Intl.message('Add Address', name: 'add_address', desc: '', args: []);
  }

  /// `Building Number`
  String get building_number {
    return Intl.message(
      'Building Number',
      name: 'building_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter building number here`
  String get enter_building_number {
    return Intl.message(
      'Enter building number here',
      name: 'enter_building_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter address here`
  String get enter_address {
    return Intl.message(
      'Enter address here',
      name: 'enter_address',
      desc: '',
      args: [],
    );
  }

  /// `Apartment Number`
  String get apartment_number {
    return Intl.message(
      'Apartment Number',
      name: 'apartment_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter apartment number here`
  String get enter_apartment_number {
    return Intl.message(
      'Enter apartment number here',
      name: 'enter_apartment_number',
      desc: '',
      args: [],
    );
  }

  /// `Floor Number`
  String get floor_number {
    return Intl.message(
      'Floor Number',
      name: 'floor_number',
      desc: '',
      args: [],
    );
  }

  /// `Enter floor number here`
  String get enter_floor_number {
    return Intl.message(
      'Enter floor number here',
      name: 'enter_floor_number',
      desc: '',
      args: [],
    );
  }

  /// `Address Type`
  String get address_type {
    return Intl.message(
      'Address Type',
      name: 'address_type',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Shipment Number`
  String get shipmentNumber {
    return Intl.message(
      'Shipment Number',
      name: 'shipmentNumber',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `With Delivery`
  String get with_delivery {
    return Intl.message(
      'With Delivery',
      name: 'with_delivery',
      desc: '',
      args: [],
    );
  }

  /// `Order placed`
  String get order_status_pending {
    return Intl.message(
      'Order placed',
      name: 'order_status_pending',
      desc: '',
      args: [],
    );
  }

  /// `Preparing`
  String get order_status_preparing {
    return Intl.message(
      'Preparing',
      name: 'order_status_preparing',
      desc: '',
      args: [],
    );
  }

  /// `With courier`
  String get order_status_shipping {
    return Intl.message(
      'With courier',
      name: 'order_status_shipping',
      desc: '',
      args: [],
    );
  }

  /// `Delivered`
  String get order_status_delivered {
    return Intl.message(
      'Delivered',
      name: 'order_status_delivered',
      desc: '',
      args: [],
    );
  }

  /// `Your evaluation matters to us`
  String get your_evaluation_matters_to_us {
    return Intl.message(
      'Your evaluation matters to us',
      name: 'your_evaluation_matters_to_us',
      desc: '',
      args: [],
    );
  }

  /// `Upload photos here`
  String get upload_photos_here {
    return Intl.message(
      'Upload photos here',
      name: 'upload_photos_here',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your rating`
  String get thank_you_for_your_rating {
    return Intl.message(
      'Thank you for your rating',
      name: 'thank_you_for_your_rating',
      desc: '',
      args: [],
    );
  }

  /// `Your opinion matters to us and helps us improve your experience. If you have any additional comments, please feel free to share them with us!`
  String get your_opinion_matters {
    return Intl.message(
      'Your opinion matters to us and helps us improve your experience. If you have any additional comments, please feel free to share them with us!',
      name: 'your_opinion_matters',
      desc: '',
      args: [],
    );
  }

  String get price_high_to_low {
    return Intl.message(
      'price_high_to_low',
      name: 'price_high_to_low',
      desc: 'Sorting option: Price from high to low',
      args: [],
    );
  }

  String get price_low_to_high {
    return Intl.message(
      'price_low_to_high',
      name: 'price_low_to_high',
      desc: 'Sorting option: Price from low to high',
      args: [],
    );
  }

  String get best_selling {
    return Intl.message(
      'best_selling',
      name: 'best_selling',
      desc: 'Sorting option: Best selling products',
      args: [],
    );
  }

  String get top_rated {
    return Intl.message(
      'top_rated',
      name: 'top_rated',
      desc: 'Sorting option: Top rated products',
      args: [],
    );
  }

  String get newest {
    return Intl.message(
      'newest',
      name: 'newest',
      desc: 'Sorting option: Newest products',
      args: [],
    );
  }

  String get upload_image_here_please {
    return Intl.message(
      'upload_image_here_please',
      name: 'upload_image_here_please',
      desc: 'Sorting option: Newest products',
      args: [],
    );
  }

  String get pleaseApplyCouponFirst {
    return Intl.message(
      'pleaseApplyCouponFirst',
      name: 'pleaseApplyCouponFirst',
      desc: 'Sorting option: Newest products',
      args: [],
    );
  }

  String get request_submitted_successfully {
    return Intl.message(
      'Your request has been submitted successfully',
      name: 'request_submitted_successfully',
      desc: '',
      args: [],
    );
  }

  /// `We will get back to you as soon as possible`
  String get we_will_reply_asap {
    return Intl.message(
      'We will get back to you as soon as possible',
      name: 'we_will_reply_asap',
      desc: '',
      args: [],
    );
  }

  /// `Guest`
  String get guest {
    return Intl.message('Guest', name: 'guest', desc: '', args: []);
  }

  /// `Duration between cycles`
  String get DurationCycles {
    return Intl.message(
      'Duration between cycles',
      name: 'DurationCycles',
      desc: '',
      args: [],
    );
  }

  /// `Suggested for you`
  String get suggested_for_you {
    return Intl.message(
      'Suggested for you',
      name: 'suggested_for_you',
      desc: '',
      args: [],
    );
  }

  /// `No products found`
  String get no_products_found {
    return Intl.message(
      'No products found',
      name: 'no_products_found',
      desc: '',
      args: [],
    );
  }

  /// `Continue as Visitor`
  String get continueAsVisitor {
    return Intl.message(
      'Continue as Visitor',
      name: 'continueAsVisitor',
      desc: '',
      args: [],
    );
  }

  /// `Beauty Consultation`
  String get beautyConsultation {
    return Intl.message(
      'Beauty Consultation',
      name: 'beautyConsultation',
      desc: '',
      args: [],
    );
  }

  /// `Create Account or Login`
  String get createAccountOrLogin {
    return Intl.message(
      'Create Account or Login',
      name: 'createAccountOrLogin',
      desc: '',
      args: [],
    );
  }

  /// `Please login to access this content`
  String get pleaseLoginToAccessContent {
    return Intl.message(
      'Please login to access this content',
      name: 'pleaseLoginToAccessContent',
      desc: '',
      args: [],
    );
  }

  /// `Add Medication`
  String get addMedication {
    return Intl.message(
      'Add Medication',
      name: 'addMedication',
      desc: '',
      args: [],
    );
  }

  /// `Add Contraceptive Medication`
  String get addContraceptiveMedication {
    return Intl.message(
      'Add Contraceptive Medication',
      name: 'addContraceptiveMedication',
      desc: '',
      args: [],
    );
  }

  /// `The dose has been taken`
  String get the_dose_has_been_taken {
    return Intl.message(
      'The dose has been taken',
      name: 'the_dose_has_been_taken',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete?`
  String get confirmDelete {
    return Intl.message(
      'Are you sure you want to delete?',
      name: 'confirmDelete',
      desc: '',
      args: [],
    );
  }

  /// `Delete only for today`
  String get deleteOnlyForToday {
    return Intl.message(
      'Delete only for today',
      name: 'deleteOnlyForToday',
      desc: '',
      args: [],
    );
  }

  /// `Delete the medication completely`
  String get deleteCompletely {
    return Intl.message(
      'Delete the medication completely',
      name: 'deleteCompletely',
      desc: '',
      args: [],
    );
  }

  /// `Total Deletion`
  String get totalDeletion {
    return Intl.message(
      'Total Deletion',
      name: 'totalDeletion',
      desc: '',
      args: [],
    );
  }

  /// `Payment Options`
  String get paymentOptions {
    return Intl.message(
      'Payment Options',
      name: 'paymentOptions',
      desc: '',
      args: [],
    );
  }

  /// `Cash on Delivery`
  String get cashOn {
    return Intl.message('Cash on Delivery', name: 'cashOn', desc: '', args: []);
  }

  /// `Upload the conversion image`
  String get upload_the_conversion_image {
    return Intl.message(
      'Upload the conversion image',
      name: 'upload_the_conversion_image',
      desc: '',
      args: [],
    );
  }

  /// `Do you have a comment?`
  String get do_you_have_a_comment {
    return Intl.message(
      'Do you have a comment?',
      name: 'do_you_have_a_comment',
      desc: '',
      args: [],
    );
  }

  /// `Login Required`
  String get loginRequired {
    return Intl.message(
      'Login Required',
      name: 'loginRequired',
      desc: '',
      args: [],
    );
  }

  /// `Once`
  String get once {
    return Intl.message('Once', name: 'once', desc: '', args: []);
  }

  /// `Medicine Name`
  String get medicine_name {
    return Intl.message(
      'Medicine Name',
      name: 'medicine_name',
      desc: '',
      args: [],
    );
  }

  /// `Enter medicine name`
  String get enter_medicine_name {
    return Intl.message(
      'Enter medicine name',
      name: 'enter_medicine_name',
      desc: '',
      args: [],
    );
  }

  /// `Please enter medicine name`
  String get please_enter_medicine_name {
    return Intl.message(
      'Please enter medicine name',
      name: 'please_enter_medicine_name',
      desc: '',
      args: [],
    );
  }

  /// `Add notes`
  String get add_notes {
    return Intl.message('Add notes', name: 'add_notes', desc: '', args: []);
  }

  /// `Add Photo`
  String get add_photo {
    return Intl.message('Add Photo', name: 'add_photo', desc: '', args: []);
  }

  /// `Delete Photo`
  String get delete_photo {
    return Intl.message(
      'Delete Photo',
      name: 'delete_photo',
      desc: '',
      args: [],
    );
  }

  /// `Quantity per Time`
  String get quantity_per_time {
    return Intl.message(
      'Quantity per Time',
      name: 'quantity_per_time',
      desc: '',
      args: [],
    );
  }

  /// `Medication Schedules`
  String get medication_schedules {
    return Intl.message(
      'Medication Schedules',
      name: 'medication_schedules',
      desc: '',
      args: [],
    );
  }

  /// `No times added yet`
  String get no_times_added_yet {
    return Intl.message(
      'No times added yet',
      name: 'no_times_added_yet',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add time`
  String get failed_to_add_time {
    return Intl.message(
      'Failed to add time',
      name: 'failed_to_add_time',
      desc: '',
      args: [],
    );
  }

  /// `Repeat Alert`
  String get repeat_alert {
    return Intl.message(
      'Repeat Alert',
      name: 'repeat_alert',
      desc: '',
      args: [],
    );
  }

  /// `Reminder Once`
  String get reminder_once {
    return Intl.message(
      'Reminder Once',
      name: 'reminder_once',
      desc: '',
      args: [],
    );
  }

  /// `Every Day`
  String get every_day {
    return Intl.message('Every Day', name: 'every_day', desc: '', args: []);
  }

  /// `Select Days`
  String get select_days {
    return Intl.message('Select Days', name: 'select_days', desc: '', args: []);
  }

  /// `Alert`
  String get alert {
    return Intl.message('Alert', name: 'alert', desc: '', args: []);
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Saving...`
  String get saving {
    return Intl.message('Saving...', name: 'saving', desc: '', args: []);
  }

  /// `Please add at least one time`
  String get please_add_at_least_one_time {
    return Intl.message(
      'Please add at least one time',
      name: 'please_add_at_least_one_time',
      desc: '',
      args: [],
    );
  }

  /// `Please select at least one day`
  String get please_select_at_least_one_day {
    return Intl.message(
      'Please select at least one day',
      name: 'please_select_at_least_one_day',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while preparing data. Please try again.`
  String get error_preparing_data {
    return Intl.message(
      'Error occurred while preparing data. Please try again.',
      name: 'error_preparing_data',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error occurred`
  String get unknown_error {
    return Intl.message(
      'Unknown error occurred',
      name: 'unknown_error',
      desc: '',
      args: [],
    );
  }

  /// `Failed to add medicine`
  String get failed_to_add_medicine {
    return Intl.message(
      'Failed to add medicine',
      name: 'failed_to_add_medicine',
      desc: '',
      args: [],
    );
  }

  String get periodLength {
    return Intl.message(
      'Failed to Period Length',
      name: 'periodLength',
      desc: '',
      args: [],
    );
  }

  String get pregnancyChance {
    return Intl.message(
      'Failed to Pregnancy Chance',
      name: 'pregnancyChance',
      desc: '',
      args: [],
    );
  }

  String get level {
    return Intl.message('Failed to Level', name: 'level', desc: '', args: []);
  }

  String get periodDays {
    return Intl.message(
      'Failed to period Days',
      name: 'periodDays',
      desc: '',
      args: [],
    );
  }

  String get cycleLengthMax {
    return Intl.message(
      'Failed to cycleLengthMax',
      name: 'cycleLengthMax',
      desc: '',
      args: [],
    );
  }

  String get periodLengthMax {
    return Intl.message(
      'Failed to periodLengthMax',
      name: 'periodLengthMax',
      desc: '',
      args: [],
    );
  }

  String get selectDate {
    return Intl.message(
      'Failed to selectDate',
      name: 'selectDate',
      desc: '',
      args: [],
    );
  }

  String get fasting {
    return Intl.message(
      'Failed to fasting',
      name: 'fasting',
      desc: '',
      args: [],
    );
  }

  String get afterMeal {
    return Intl.message(
      'Failed to afterMeal',
      name: 'afterMeal',
      desc: '',
      args: [],
    );
  }

  String get random {
    return Intl.message('Failed to random', name: 'random', desc: '', args: []);
  }

  String get requiredFeilds {
    return Intl.message(
      'Failed to requiredFeilds',
      name: 'requiredFeilds',
      desc: '',
      args: [],
    );
  }

  String get feildRequired {
    return Intl.message(
      'Failed to feildRequired',
      name: 'feildRequired',
      desc: '',
      args: [],
    );
  }

  String get male {
    return Intl.message('Failed to male', name: 'male', desc: '', args: []);
  }

  String get female {
    return Intl.message('Failed to female', name: 'female', desc: '', args: []);
  }

  String get loading {
    return Intl.message(
      'Failed to loading',
      name: 'loading',
      desc: '',
      args: [],
    );
  }

  String get noVaccines {
    return Intl.message(
      'Failed to noVaccines',
      name: 'noVaccines',
      desc: '',
      args: [],
    );
  }

  String get loaded {
    return Intl.message('Failed to loaded', name: 'loaded', desc: '', args: []);
  }

  String get notificationsScheduled {
    return Intl.message(
      'Failed to notificationsScheduled',
      name: 'notificationsScheduled',
      desc: '',
      args: [],
    );
  }

  String get vaccineReminderTitle {
    return Intl.message(
      'Failed to vaccineReminderTitle',
      name: 'vaccineReminderTitle',
      desc: '',
      args: [],
    );
  }

  String get noAddressesFound {
    return Intl.message(
      'Failed to noAddressesFound',
      name: 'noAddressesFound',
      desc: '',
      args: [],
    );
  }

  String get PhoneAlreadyExists {
    return Intl.message(
      'Failed to PhoneAlreadyExists',
      name: 'PhoneAlreadyExists',
      desc: '',
      args: [],
    );
  }

  String get favouriteEmpty {
    return Intl.message(
      'Failed to favouriteEmpty',
      name: 'favouriteEmpty',
      desc: '',
      args: [],
    );
  }

  String get noOrders {
    return Intl.message(
      'Failed to noOrders',
      name: 'noOrders',
      desc: '',
      args: [],
    );
  }

  String get shippingAddress {
    return Intl.message(
      'Failed to shippingAddress',
      name: 'shippingAddress',
      desc: '',
      args: [],
    );
  }

  String get deliveryFee {
    return Intl.message(
      'Failed to deliveryFee',
      name: 'deliveryFee',
      desc: '',
      args: [],
    );
  }

  String get pointsEarned {
    return Intl.message(
      'Failed to pointsEarned',
      name: 'pointsEarned',
      desc: '',
      args: [],
    );
  }

  String get gift {
    return Intl.message('Failed to gift', name: 'gift', desc: '', args: []);
  }

  String get size {
    return Intl.message('Failed to size', name: 'size', desc: '', args: []);
  }

  String get nogitf {
    return Intl.message('Failed to nogitf', name: 'nogitf', desc: '', args: []);
  }

  String get landMark {
    return Intl.message(
      'Failed to landMark',
      name: 'landMark',
      desc: '',
      args: [],
    );
  }

  String get pending {
    return Intl.message(
      'Failed to pending',
      name: 'pending',
      desc: '',
      args: [],
    );
  }

  String get are_you_sure {
    return Intl.message(
      'Failed to are_you_sure',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  String get no_images {
    return Intl.message(
      'Failed to no_images',
      name: 'no_images',
      desc: '',
      args: [],
    );
  }

  String get defultAddress {
    return Intl.message(
      'Failed to defultAddress',
      name: 'defaultAddress',
      desc: '',
      args: [],
    );
  }

  String get noReturns {
    return Intl.message(
      'Failed to noReturns',
      name: 'noReturns',
      desc: '',
      args: [],
    );
  }

  String get reviewsEmpty {
    return Intl.message(
      'Failed to reviewsEmpty',
      name: 'reviewsEmpty',
      desc: '',
      args: [],
    );
  }

  String get noResultsFound {
    return Intl.message(
      'Failed to noResultsFound',
      name: 'noResultsFound',
      desc: '',
      args: [],
    );
  }

  String get promoCodeExpired {
    return Intl.message(
      'Failed to promoCodeExpired',
      name: 'promoCodeExpired',
      desc: '',
      args: [],
    );
  }

  String get noPhoneNumber {
    return Intl.message(
      'Failed to noPhoneNumber',
      name: 'noPhoneNumber',
      desc: '',
      args: [],
    );
  }

  String get yourEmailAlready {
    return Intl.message(
      'Failed to yourEmailAlready',
      name: 'yourEmailAlready',
      desc: '',
      args: [],
    );
  }

  String get emailNotFound {
    return Intl.message(
      'Failed to emailNotFound',
      name: 'emailNotFound',
      desc: '',
      args: [],
    );
  }

  String get enterstreet {
    return Intl.message(
      'Failed to enterstreet',
      name: 'enterstreet',
      desc: '',
      args: [],
    );
  }

  String get enter_street_num {
    return Intl.message(
      'Failed to enter_street_num',
      name: 'enter_street_num',
      desc: '',
      args: [],
    );
  }

  String get reviewYouData {
    return Intl.message(
      'Failed to reviewYouData',
      name: 'reviewYouData',
      desc: '',
      args: [],
    );
  }

  String get startNow {
    return Intl.message(
      'Failed to startNow',
      name: 'startNow',
      desc: '',
      args: [],
    );
  }

  String get skip {
    return Intl.message('Failed to skip', name: 'skip', desc: '', args: []);
  }

  String get onb1Title {
    return Intl.message(
      'Failed to onb1Title',
      name: 'onb1Title',
      desc: '',
      args: [],
    );
  }

  String get onb1Subtitle {
    return Intl.message(
      'Failed to onb1Subtitle',
      name: 'onb1Subtitle',
      desc: '',
      args: [],
    );
  }

  String get onb2Title {
    return Intl.message(
      'Failed to onb2Title',
      name: 'onb2Title',
      desc: '',
      args: [],
    );
  }

  String get onb2Subtitle {
    return Intl.message(
      'Failed to onb2Subtitle',
      name: 'onb2Subtitle',
      desc: '',
      args: [],
    );
  }

  String get onb3Title {
    return Intl.message(
      'Failed to onb3Title',
      name: 'onb3Title',
      desc: '',
      args: [],
    );
  }

  String get onb3Subtitle {
    return Intl.message(
      'Failed to onb3Subtitle',
      name: 'onb3Subtitle',
      desc: '',
      args: [],
    );
  }

  String get pressAgainToExit {
    return Intl.message(
      'Failed to pressAgainToExit',
      name: 'pressAgainToExit',
      desc: '',
      args: [],
    );
  }

  String get loginUser {
    return Intl.message(
      'Failed to loginUser',
      name: 'loginUser',
      desc: '',
      args: [],
    );
  }

  String get pleaseEnter {
    return Intl.message(
      'Failed to pleaseEnter',
      name: 'pleaseEnter',
      desc: '',
      args: [],
    );
  }

  String get wrong_email_pass {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'wrong_email_pass',
      desc: '',
      args: [],
    );
  }

  String get connectionTimeout {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'connectionTimeout',
      desc: '',
      args: [],
    );
  }

  String get sendTimeout {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'sendTimeout',
      desc: '',
      args: [],
    );
  }

  String get receiveTimeout {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'receiveTimeout',
      desc: '',
      args: [],
    );
  }

  String get badResponse {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'badResponse',
      desc: '',
      args: [],
    );
  }

  String get requestCancelled {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'requestCancelled',
      desc: '',
      args: [],
    );
  }

  String get noInternet {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'noInternet',
      desc: '',
      args: [],
    );
  }

  String get unexpectedNetworkError {
    return Intl.message(
      'Failed to wrong_email_pass',
      name: 'unexpectedNetworkError',
      desc: '',
      args: [],
    );
  }

  String get retry {
    return Intl.message('Failed to retry', name: 'retry', desc: '', args: []);
  }

  String get check {
    return Intl.message('Failed to check', name: 'check', desc: '', args: []);
  }

  String get no_resent {
    return Intl.message(
      'Failed to no_resent',
      name: 'no_resent',
      desc: '',
      args: [],
    );
  }

  String get orderIsNowPending {
    return Intl.message(
      'Failed to orderIsNowPending',
      name: 'orderIsNowPending',
      desc: '',
      args: [],
    );
  }

  String get orderRejected {
    return Intl.message(
      'Failed to orderRejected',
      name: 'orderRejected',
      desc: '',
      args: [],
    );
  }

  String get orderIsNowConfirmed {
    return Intl.message(
      'Failed to orderIsNowConfirmed',
      name: 'orderIsNowConfirmed',
      desc: '',
      args: [],
    );
  }

  String get orderDelivered {
    return Intl.message(
      'Failed toorderDeliveredt',
      name: 'orderDelivered',
      desc: '',
      args: [],
    );
  }

  String get orderCacelled {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'orderCacelled',
      desc: '',
      args: [],
    );
  }

  String get facebook {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'facebook',
      desc: '',
      args: [],
    );
  }

  String get insta {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'insta',
      desc: '',
      args: [],
    );
  }

  String get tik {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'tik',
      desc: '',
      args: [],
    );
  }

  String get youtube {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'youtube',
      desc: '',
      args: [],
    );
  }

  String get editMedicne {
    return Intl.message(
      'Failed editMedicne',
      name: 'editMedicne',
      desc: '',
      args: [],
    );
  }

  String get medicineEditedSuccessfully {
    return Intl.message(
      'Failed medicineEditedSuccessfully',
      name: 'medicineEditedSuccessfully',
      desc: '',
      args: [],
    );
  }

  String get warinign {
    return Intl.message(
      'Failed warinign',
      name: 'warinign',
      desc: '',
      args: [],
    );
  }

  String get phone {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  String get location {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  String get onceReminder {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'onceReminder',
      desc: '',
      args: [],
    );
  }

  String get dailyReminder {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'dailyReminder',
      desc: '',
      args: [],
    );
  }

  String get specificDaysReminder {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'specificDaysReminder',
      desc: '',
      args: [],
    );
  }

  String get errorEnterMedicineName {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'errorEnterMedicineName',
      desc: '',
      args: [],
    );
  }

  String get errorAddTime {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'errorAddTime',
      desc: '',
      args: [],
    );
  }

  String get errorSelectOnceDay {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'errorSelectOnceDay',
      desc: '',
      args: [],
    );
  }

  String get errorSelectSpecificDays {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'errorSelectSpecificDays',
      desc: '',
      args: [],
    );
  }

  String get deliveryValue {
    return Intl.message(
      'Failed deliveryValue',
      name: 'deliveryValue',
      desc: '',
      args: [],
    );
  }

  String get pleaseSelectGovernorate {
    return Intl.message(
      'Failed pleaseSelectGovernorate',
      name: 'pleaseSelectGovernorate',
      desc: '',
      args: [],
    );
  }

  String get failedToLoad {
    return Intl.message(
      'Failed failedToLoad',
      name: 'failedToLoad',
      desc: '',
      args: [],
    );
  }

  String get feildRequiredalso {
    return Intl.message(
      'Failed feildRequiredalso',
      name: 'feildRequiredalso',
      desc: '',
      args: [],
    );
  }

  String get no_cities {
    return Intl.message(
      'Failed no_cities',
      name: 'no_cities',
      desc: '',
      args: [],
    );
  }

  String get unnamedMedicine {
    return Intl.message(
      'Failed torderCacellednt',
      name: 'unnamedMedicine',
      desc: '',
      args: [],
    );
  }

  String get onlyUpdateToday {
    return Intl.message(
      'Failed onlyUpdateToday',
      name: 'onlyUpdateToday',
      desc: '',
      args: [],
    );
  }

  String get timeToTakeYourMedicine {
    return Intl.message(
      'Failed timeToTakeYourMedicine',
      name: 'timeToTakeYourMedicine',
      desc: '',
      args: [],
    );
  }

  String get stopAlarm {
    return Intl.message(
      'Failed stopAlarm',
      name: 'stopAlarm',
      desc: '',
      args: [],
    );
  }

  String get sizeNoAvaibleNow {
    return Intl.message(
      'Failed sizeNoAvaibleNow',
      name: 'sizeNoAvaibleNow',
      desc: '',
      args: [],
    );
  }

  String get pleaseWait {
    return Intl.message(
      'Failed pleaseWait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  String get noPointsEarned {
    return Intl.message(
      'Failed noPointsEarned',
      name: 'noPointsEarned',
      desc: '',
      args: [],
    );
  }

  String get valid {
    return Intl.message('Failed valid', name: 'valid', desc: '', args: []);
  }

  String get notValid {
    return Intl.message(
      'Failed notValid',
      name: 'notValid',
      desc: '',
      args: [],
    );
  }

  String get redeemedAt {
    return Intl.message(
      'Failed redeemedAt',
      name: 'redeemedAt',
      desc: '',
      args: [],
    );
  }

  String get expired_at {
    return Intl.message(
      'Failed expired_at',
      name: 'expired_at',
      desc: '',
      args: [],
    );
  }

  String get childred {
    return Intl.message(
      'Failed childred',
      name: 'childred',
      desc: '',
      args: [],
    );
  }

  String get no_childred {
    return Intl.message(
      'Failed no_childred',
      name: 'no_childred',
      desc: '',
      args: [],
    );
  }

  String get take {
    return Intl.message('Failed take', name: 'take', desc: '', args: []);
  }

  String get dose {
    return Intl.message('Failed dose', name: 'dose', desc: '', args: []);
  }

  String get missedVac {
    return Intl.message(
      'Failed missedVac',
      name: 'missedVac',
      desc: '',
      args: [],
    );
  }

  String get completedVac {
    return Intl.message(
      'Failed completedVac',
      name: 'completedVac',
      desc: '',
      args: [],
    );
  }

  String get addChild {
    return Intl.message(
      'Failed addChild',
      name: 'addChild',
      desc: '',
      args: [],
    );
  }

  String get note {
    return Intl.message('Failed note', name: 'note', desc: '', args: []);
  }

  String get servicesServices {
    return Intl.message(
      'Failed note',
      name: 'servicesServices',
      desc: '',
      args: [],
    );
  }

  String get medicalTipsServices {
    return Intl.message(
      'Failed note',
      name: 'medicalTipsServices',
      desc: '',
      args: [],
    );
  }

  String get ovulation_calculator {
    return Intl.message(
      'Failed note',
      name: 'ovulation_calculator',
      desc: '',
      args: [],
    );
  }

  String get pregnancy_calculator {
    return Intl.message(
      'Failed note',
      name: 'pregnancy_calculator',
      desc: '',
      args: [],
    );
  }

  String get blood_pressure {
    return Intl.message(
      'Failed note',
      name: 'blood_pressure',
      desc: '',
      args: [],
    );
  }

  String get blood_sugar {
    return Intl.message('Failed note', name: 'blood_sugar', desc: '', args: []);
  }

  String get body_weight {
    return Intl.message('Failed note', name: 'body_weight', desc: '', args: []);
  }

  String get vaccination_schedule {
    return Intl.message(
      'Failed note',
      name: 'vaccination_schedule',
      desc: '',
      args: [],
    );
  }

  String get ask_pharmacist {
    return Intl.message(
      'Failed note',
      name: 'ask_pharmacist',
      desc: '',
      args: [],
    );
  }

  String get beauty_consultation {
    return Intl.message(
      'Failed note',
      name: 'beauty_consultation',
      desc: '',
      args: [],
    );
  }

  String get fertility_calendar {
    return Intl.message(
      'Failed note',
      name: 'fertility_calendar',
      desc: '',
      args: [],
    );
  }

  String get start_period_calc {
    return Intl.message(
      'Failed note',
      name: 'start_period_calc',
      desc: '',
      args: [],
    );
  }

  String get date2 {
    return Intl.message('Failed note', name: 'date2', desc: '', args: []);
  }

  String get phase {
    return Intl.message('Failed note', name: 'phase', desc: '', args: []);
  }

  String get pregnancy_chance {
    return Intl.message(
      'Failed note',
      name: 'pregnancy_chance',
      desc: '',
      args: [],
    );
  }

  String get enternewDate {
    return Intl.message(
      'Failed enternewDate',
      name: 'enternewDate',
      desc: '',
      args: [],
    );
  }

  String get doneSchedule {
    return Intl.message(
      'Failed doneSchedule',
      name: 'doneSchedule',
      desc: '',
      args: [],
    );
  }

  String get newPregnaancy {
    return Intl.message(
      'Failed newPregnaancy',
      name: 'newPregnaancy',
      desc: '',
      args: [],
    );
  }

  String get evening {
    return Intl.message('Failed evening', name: 'evening', desc: '', args: []);
  }

  String get morning {
    return Intl.message('Failed morning', name: 'morning', desc: '', args: []);
  }

  String get cm {
    return Intl.message('Failed cm', name: 'cm', desc: '', args: []);
  }

  String get congrats {
    return Intl.message(
      'Failed congrats',
      name: 'congrats',
      desc: '',
      args: [],
    );
  }

  String get youRecieved {
    return Intl.message(
      'Failed youRecieved',
      name: 'youRecieved',
      desc: '',
      args: [],
    );
  }

  String get days {
    return Intl.message('Failed days', name: 'days', desc: '', args: []);
  }

  String get addressOfTake {
    return Intl.message(
      'Failed addressOfTake',
      name: 'addressOfTake',
      desc: '',
      args: [],
    );
  }

  String get shareProduct {
    return Intl.message(
      'Check out this product',
      name: 'shareProduct',
      desc: 'Title for sharing a product',
      args: [],
    );
  }

  // Price label
  String get priceLabel {
    return Intl.message(
      'Price',
      name: 'priceLabel',
      desc: 'Label for the product price',
      args: [],
    );
  }

  // View link label
  String get viewHere {
    return Intl.message(
      'View it here',
      name: 'viewHere',
      desc: 'Label for product link',
      args: [],
    );
  }

  // View link label
  String get contantInfo {
    return Intl.message(
      'View it here',
      name: 'contactNum',
      desc: 'Label for product link',
      args: [],
    );
  } // View link label

  String get electricPay {
    return Intl.message(
      'electricPay',
      name: 'electricPay',
      desc: 'Label for product link',
      args: [],
    );
  }

  String get are_you_sure_to_delete {
    return Intl.message(
      'are_you_sure_to_delete',
      name: 'are_you_sure_to_delete',
      desc: 'Label for are_you_sure_to_delete',
      args: [],
    );
  }

  String get deleted_successfully {
    return Intl.message(
      'deleted_successfully',
      name: 'deleted_successfully',
      desc: 'Label for deleted_successfully',
      args: [],
    );
  }

  String get delete_failed {
    return Intl.message(
      'delete_failed',
      name: 'delete_failed',
      desc: 'Label for delete_failed',
      args: [],
    );
  }

  String get pleaseEnterPhoneNumber {
    return Intl.message(
      'pleaseEnterPhoneNumber',
      name: 'pleaseEnterPhoneNumber',
      desc: 'Label for pleaseEnterPhoneNumber',
      args: [],
    );
  }

  String get qiCard {
    return Intl.message(
      'InstaPay',
      name: 'qiCard',
      desc: 'Label for qiCard',
      args: [],
    );
  }

  String get cycleLengthMin {
    return Intl.message(
      'cycleLengthMin',
      name: 'cycleLengthMin',
      desc: 'Label for cycleLengthMin',
      args: [],
    );
  }

  String get periodMin {
    return Intl.message(
      'periodMin',
      name: 'periodMin',
      desc: 'Label for periodMin',
      args: [],
    );
  }

  String get cycleAndPeriodError {
    return Intl.message(
      'cycleAndPeriodError',
      name: 'cycleAndPeriodError',
      desc: 'Label for cycleAndPeriodError',
      args: [],
    );
  }

  String get onDelivery {
    return Intl.message(
      'onDelivery',
      name: 'onDelivery',
      desc: 'Label for onDelivery',
      args: [],
    );
  }

  String get readAll {
    return Intl.message(
      'readAll',
      name: 'readAll',
      desc: 'Label for readAll',
      args: [],
    );
  }

  String get today {
    return Intl.message(
      'today',
      name: 'today',
      desc: 'Label for today',
      args: [],
    );
  }

  String get yesterday {
    return Intl.message(
      'yesterday',
      name: 'yesterday',
      desc: 'Label for yesterday',
      args: [],
    );
  }

  String get phoneNumberOptional {
    return Intl.message(
      'phoneNumberOptional',
      name: 'phoneNumberOptional',
      desc: 'Label for phoneNumberOptional',
      args: [],
    );
  }
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
