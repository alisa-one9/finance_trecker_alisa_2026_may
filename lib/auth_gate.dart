import 'package:finance_trecker_alisa/ui/code_enter_page.dart';
import 'package:finance_trecker_alisa/ui/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/main_navigation_container.dart';
import 'enter_logic/enter_cubit/enter_auth_cubit.dart';
import 'enter_logic/enter_states/enter_auth_state.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnterAuthCubit, EnterAuthState>(
      builder: (context, state) {
        if (state.isSuccess) return const MainNavigationContainer();
        if (state.isFirstRun) return const RegistrationPage();
        return const CodEnterPage();
      },
    );
  }
}
