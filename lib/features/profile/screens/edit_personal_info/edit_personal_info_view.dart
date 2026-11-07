import 'package:elkawther/core/routes/routes.dart';
import 'package:elkawther/core/theme/app_padding.dart';
import 'package:elkawther/core/utils/validators.dart';
import 'package:elkawther/core/widgets/app_snack_bar.dart';
import 'package:elkawther/core/widgets/custom_text_form_field.dart';
import 'package:elkawther/core/widgets/text_field_with_custom_label.dart';
import 'package:elkawther/features/profile/cubit/profile_cubit.dart';
import 'package:elkawther/features/profile/models/user_model.dart';
import 'package:elkawther/features/profile/widgets/profile_list_tile.dart';
import 'package:elkawther/features/profile/widgets/profile_scaffold.dart';
import 'package:elkawther/generated/assets.dart';
import 'package:elkawther/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPersonalInfo extends StatefulWidget {
  const EditPersonalInfo({super.key});

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<ProfileCubit>().userData;
    if (user != null) {
      _fill(user);
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
    }
  }

  Future<void> _loadUser() async {
    await context.read<ProfileCubit>().getUserData();
    if (!mounted) return;
    final user = context.read<ProfileCubit>().userData;
    if (user != null) _fill(user);
  }

  void _fill(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<ProfileCubit>();
    final current = cubit.userData;
    if (current == null || current.id == 0) {
      AppSnackBar.error(S.of(context).unexpectedError);
      return;
    }

    setState(() => _saving = true);
    await cubit.editDataUser(
      current.id,
      _emailController.text.trim(),
      _nameController.text.trim(),
      _phoneController.text.trim(),
      context,
    );
    if (!mounted) return;
    setState(() => _saving = false);

    final state = cubit.state;
    if (state is ProfileEditErrorState) {
      final message = state.message?.localizedMessage(context) ?? '';
      AppSnackBar.error(
        message.isEmpty ? S.of(context).unexpectedError : message,
      );
      return;
    }
    AppSnackBar.success(S.of(context).loaded);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    return ProfileScaffold(
      title: S.of(context).editProfile,
      subtitle: isAr ? 'عدّل بيانات حسابك' : 'Update your account details',
      bottom: ProfilePrimaryButton(
        title: S.of(context).save,
        isLoading: _saving,
        onPressed: _saving ? null : _save,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          ProfileFormCard(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldCustomLabel(label: S.of(context).name),
                  CustomTextFormField(
                    hintText: S.of(context).enterName,
                    controller: _nameController,
                    validator: (value) =>
                        Validators.validateName(context, value),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  TextFieldCustomLabel(label: S.of(context).email),
                  CustomTextFormField(
                    hintText: S.of(context).enterEmailHere,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    validator: (value) =>
                        Validators.validateEmail(context, value),
                  ),
                  const SizedBox(height: AppPadding.medium),
                  TextFieldCustomLabel(label: S.of(context).phone_number),
                  CustomTextFormField(
                    hintText: S.of(context).enter_phone_number_here,
                    keyboardType: TextInputType.phone,
                    controller: _phoneController,
                    validator: (value) =>
                        Validators.validatePhone(context, value),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ProfileListTile(
            icon: Assets.iconsPassword2,
            title: S.of(context).password,
            onTap: () => Navigator.pushNamed(context, Routes.editPassword),
          ),
        ],
      ),
    );
  }
}
