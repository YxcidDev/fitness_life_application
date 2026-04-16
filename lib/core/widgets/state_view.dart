import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';

class StateView extends StatelessWidget {
  final Widget? child;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onRetry;

  const StateView({
    super.key,
    this.child,
    this.isLoading = false,
    this.errorMessage,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _BaseContainer(
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: kOrange),
            SizedBox(height: 16),
            Text('Procesando...',
                style: TextStyle(color: kGrey)),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return _BaseContainer(
        borderColor: Colors.red,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              errorMessage!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: kDark),
            ),
            const SizedBox(height: 20),
            if (onRetry != null)
              AppButton(
                label: 'Reintentar',
                onTap: onRetry!,
              ),
          ],
        ),
      );
    }

    return _BaseContainer(child: child ?? const SizedBox());
  }
}

class _BaseContainer extends StatelessWidget {
  final Widget child;
  final Color borderColor;

  const _BaseContainer({
    required this.child,
    this.borderColor = kLightGrey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Center(child: child),
    );
  }
}