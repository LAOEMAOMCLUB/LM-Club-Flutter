// resetPasswordPage here we can reset password once otp sent to entered mobileNumber.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:lm_club/app/core/di/locator.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_bloc.dart';
import 'package:lm_club/app/presentation/forgot-password/bloc/forgot_password_state.dart';
import 'package:lm_club/routes/app_routes.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:qlevar_router/qlevar_router.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ForgotPasswordBloc _forgotPasswordBloc =
      getIt.get<ForgotPasswordBloc>();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => _forgotPasswordBloc,
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
          if (state.isSuccesful!) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color.fromRGBO(55, 74, 156, 1),
                content: Center(
                  child: Text(
                    'Password reset successfully',
                    style: TextStyle(
                      color: Color.fromRGBO(235, 237, 245, 1),
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: Duration(seconds: 2),
              ),
            );

            QR.to(Routes.SIGN_IN);

            _forgotPasswordBloc.disposeControllers();
          } else if (state.message!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Center(
                  child: Text(
                    state.message!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state.error!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Center(
                  child: Text(
                    state.error!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        }, builder: (context, state) {
          return Stack(children: [
            Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(76.0),
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(15, 9, 15, 9),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(12, 57, 131, 1),
                              Color.fromRGBO(0, 176, 80, 1),
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              blurRadius: 15.0,
                              spreadRadius: 10.0,
                            ),
                          ],
                        ),
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 3,
                          shadowColor: const Color.fromRGBO(0, 0, 0, 0.16),
                          flexibleSpace: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromRGBO(12, 57, 131, 1),
                                  Color.fromRGBO(0, 176, 80, 1),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'NeueHaasGroteskTextPro',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ),
                          leading: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Color.fromRGBO(255, 255, 255, 1)),
                              onPressed: () {
                                QR.to(Routes.FORGOT_PASSWORD);
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             const ForgotPassword()));
                              }),
                        ))),
                body: Container(
                    padding: const EdgeInsets.fromLTRB(23, 30, 23, 30),
                    child: Form(
                      key: _forgotPasswordBloc.passwordFormKey,
                      child: Column(children: [
                        Container(
                          width: 172,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 40),
                          child: const Text(
                            "Your identity has been verified, set your new password.",
                            style: TextStyle(
                                fontFamily: "NeueHaasGroteskTextPro",
                                fontSize: 12,
                                color: Color.fromRGBO(35, 44, 58, 1)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: _forgotPasswordBloc.passwordController,
                          obscureText: !_showPassword,
                          maxLength: 10,
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Password is Required'),
                            PatternValidator(
                                r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#^])[A-Za-z\d@$!%*?&#^]{6,}$",
                                errorText:
                                    'Password must have 6-10 characters in length, One Upper case, One Lower case, One Special Character.'),
                          ]),
                          decoration: InputDecoration(
                            counterStyle: const TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            // hintText: 'Password',
                            errorMaxLines: 3,
                            labelText: 'Password',
                            errorStyle: const TextStyle(fontSize: 13.0),
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(106, 106, 106, 1),
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontWeight: FontWeight.w500,
                            ),

                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 13,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontWeight: FontWeight.w400,
                            ),

                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(184, 188, 204, 1),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(184, 188, 204, 1),
                              ),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showPassword =
                                      !_showPassword; // Toggle the password visibility
                                });
                              },
                              child: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromRGBO(
                                    55, 74, 156, 1), // Change color as needed
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontSize: 13,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Confirm Password is Required';
                            } else if (val !=
                                _forgotPasswordBloc.passwordController.text
                                    .trim()) {
                              return 'Given Password and Confirm Password Not Matched';
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: !_showConfirmPassword,
                          maxLength: 10,
                          controller:
                              _forgotPasswordBloc.confirmPasswordController,
                          decoration: InputDecoration(
                            counterStyle: const TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            // hintText: 'Confirm Password',
                            errorMaxLines: 2,
                            labelText: 'Confirm Password',
                            errorStyle: const TextStyle(fontSize: 13.0),
                            labelStyle: const TextStyle(
                              fontSize: 13,
                              color: Color.fromRGBO(106, 106, 106, 1),
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontWeight: FontWeight.w500,
                            ),

                            hintStyle: const TextStyle(
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontSize: 13,
                              fontFamily: 'NeueHaasGroteskTextPro',
                              fontWeight: FontWeight.w400,
                            ),

                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(184, 188, 204, 1),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color.fromRGBO(184, 188, 204, 1),
                              ),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _showConfirmPassword = !_showConfirmPassword;
                                });
                              },
                              child: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromRGBO(55, 74, 156, 1),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Color.fromRGBO(27, 27, 27, 1),
                            fontSize: 13,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            _forgotPasswordBloc.resetPassword();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(55, 74, 156, 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            elevation: 4,
                          ),
                          child: const SizedBox(
                            width: 150,
                            height: 42,
                            child: Center(
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                    fontFamily: "NeueHaasGroteskTextPro",
                                    fontSize: 14,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ))),
            if (state.isLoading)
              Container(
                color: Colors.transparent
                    .withOpacity(0.2), // Semi-transparent black overlay
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.hexagonDots(
                        size: 35,
                        color: Colors.blue,
                      ),
                      const SizedBox(height: 10), // Adjust spacing if needed
                      const Text(
                        'Loading, please wait ...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'NeueHaasGroteskTextPro',
                            decoration: TextDecoration.none),
                      ),
                    ],
                  ),
                ),
              ),
          ]);
        }));
  }
}
