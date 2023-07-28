import 'package:flutter/material.dart';
import 'package:movie_app/core/core.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    this.onTap,
    this.loading = false,
    this.width,
    this.height,
    this.titleStyle,
    this.placeHolder,
  });

  final String title;
  final VoidCallback? onTap;
  final bool loading;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final Widget? placeHolder;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      splashColor: Theme.of(context).coreTransparent,
      focusColor: Theme.of(context).coreTransparent,
      highlightColor: Theme.of(context).coreTransparent,
      onTap: onTap,
      child: Container(
        width: width ?? size.width,
        height: height ?? 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).coreBlue,
          borderRadius: BorderRadius.circular(4),
        ),
        child: loading
            ? placeHolder ??
                LThreeDotBounce(
                  size: 20,
                  color: Theme.of(context).coreWhite,
                )
            : Text(
                title,
                style: titleStyle ??
                    Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: Theme.of(context).coreWhite),
              ),
      ),
    );
  }
}
