import 'package:flutter/material.dart';

import '../main.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool registerMode = false;
  bool obscure = true;
  bool submitting = false;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;
    final state = AppScope.of(context);
    setState(() => submitting = true);
    final error = registerMode
        ? await state.register(
            name: name.text,
            username: username.text,
            email: email.text,
            password: password.text,
          )
        : await state.login(email.text, password.text);
    if (!mounted) return;
    setState(() => submitting = false);
    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFDB2777)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(Icons.movie_filter_rounded, size: 40),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'فیلم‌یاب',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    registerMode
                        ? 'حساب بساز و تماشایت را ثبت کن'
                        : 'دنیای فیلم و سریال‌های تو',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 30),
                  if (registerMode) ...[
                    TextFormField(
                      controller: name,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'نام و نام خانوادگی',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      validator: (v) => v == null || v.trim().length < 2
                          ? 'نام را وارد کنید'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: username,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'نام کاربری',
                        prefixIcon: Icon(Icons.alternate_email),
                      ),
                      validator: (v) => v == null || v.trim().length < 3
                          ? 'حداقل ۳ کاراکتر'
                          : null,
                    ),
                    const SizedBox(height: 12),
                  ],
                  TextFormField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                      labelText: 'ایمیل',
                      prefixIcon: Icon(Icons.mail_outline),
                    ),
                    validator: (v) => v != null && v.contains('@')
                        ? null
                        : 'ایمیل معتبر وارد کنید',
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: password,
                    obscureText: obscure,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                      labelText: 'رمز عبور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => obscure = !obscure),
                        icon: Icon(
                          obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (v) =>
                        v == null || v.length < 8 ? 'حداقل ۸ کاراکتر' : null,
                  ),
                  if (!registerMode)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: _changePasswordDialog,
                        child: const Text('تغییر رمز عبور'),
                      ),
                    ),
                  const SizedBox(height: 10),
                  FilledButton(
                    onPressed: submitting ? null : submit,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(17),
                    ),
                    child: submitting
                        ? const SizedBox.square(
                            dimension: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(registerMode ? 'ساخت حساب' : 'ورود'),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => registerMode = !registerMode),
                    child: Text(
                      registerMode
                          ? 'حساب دارم؛ وارد می‌شوم'
                          : 'حساب ندارم؛ ثبت‌نام',
                    ),
                  ),
                  const Divider(height: 28),
                  OutlinedButton.icon(
                    onPressed: AppScope.of(context).enterAsGuest,
                    icon: const Icon(Icons.explore_outlined),
                    label: const Text('ورود به‌عنوان مهمان'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'حساب و فعالیت‌های اعضا روی سرور پروژه ذخیره می‌شوند.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );

  Future<void> _changePasswordDialog() async {
    final draft = await showDialog<_PasswordChangeDraft>(
      context: context,
      builder: (_) => _PasswordChangeDialog(initialEmail: email.text),
    );
    if (draft == null || !mounted) return;
    email.text = draft.email;
    final error = await AppScope.of(
      context,
    ).changePassword(draft.email, draft.currentPassword, draft.newPassword);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(error ?? 'رمز عبور تغییر کرد.')));
  }
}

class _PasswordChangeDraft {
  const _PasswordChangeDraft(
    this.email,
    this.currentPassword,
    this.newPassword,
  );
  final String email;
  final String currentPassword;
  final String newPassword;
}

class _PasswordChangeDialog extends StatefulWidget {
  const _PasswordChangeDialog({required this.initialEmail});
  final String initialEmail;

  @override
  State<_PasswordChangeDialog> createState() => _PasswordChangeDialogState();
}

class _PasswordChangeDialogState extends State<_PasswordChangeDialog> {
  late final email = TextEditingController(text: widget.initialEmail);
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();

  @override
  void dispose() {
    email.dispose();
    currentPassword.dispose();
    newPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('تغییر رمز عبور'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(labelText: 'ایمیل حساب'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: currentPassword,
          obscureText: true,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(labelText: 'رمز عبور فعلی'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: newPassword,
          obscureText: true,
          textDirection: TextDirection.ltr,
          decoration: const InputDecoration(labelText: 'رمز عبور جدید'),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('انصراف'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(
          context,
          _PasswordChangeDraft(
            email.text.trim(),
            currentPassword.text,
            newPassword.text,
          ),
        ),
        child: const Text('ثبت'),
      ),
    ],
  );
}
