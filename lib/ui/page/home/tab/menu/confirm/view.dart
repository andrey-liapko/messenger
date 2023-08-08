// Copyright © 2022-2023 IT ENGINEERING MANAGEMENT INC,
//                       <https://github.com/team113>
//
// This program is free software: you can redistribute it and/or modify it under
// the terms of the GNU Affero General Public License v3.0 as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License v3.0 for
// more details.
//
// You should have received a copy of the GNU Affero General Public License v3.0
// along with this program. If not, see
// <https://www.gnu.org/licenses/agpl-3.0.html>.

import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '/l10n/l10n.dart';
import '/themes.dart';
import '/ui/widget/modal_popup.dart';
import '/ui/widget/outlined_rounded_button.dart';
import '/ui/widget/svg/svg.dart';
import '/ui/widget/text_field.dart';
import 'controller.dart';

/// View for alerting about password not being set.
///
/// Intended to be displayed with the [show] method.
class ConfirmLogoutView extends StatelessWidget {
  const ConfirmLogoutView({super.key});

  /// Displays a [ConfirmLogoutView] wrapped in a [ModalPopup].
  static Future<T?> show<T>(BuildContext context) {
    return ModalPopup.show(context: context, child: const ConfirmLogoutView());
  }

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).style;

    return GetBuilder(
      key: const Key('ConfirmLogoutView'),
      init: ConfirmLogoutController(Get.find()),
      builder: (ConfirmLogoutController c) {
        return Obx(() {
          final Widget header;
          final List<Widget> children;

          switch (c.stage.value) {
            case ConfirmLogoutViewStage.password:
              header = ModalPopupHeader(
                onBack: () => c.stage.value = null,
                text: 'btn_set_password'.l10n,
              );

              children = [
                ReactiveTextField(
                  key: const Key('PasswordField'),
                  state: c.password,
                  label: 'label_password'.l10n,
                  obscure: c.obscurePassword.value,
                  style: style.fonts.titleMedium,
                  onSuffixPressed: c.obscurePassword.toggle,
                  treatErrorAsStatus: false,
                  trailing: SvgImage.asset(
                    'assets/icons/visible_${c.obscurePassword.value ? 'off' : 'on'}.svg',
                    width: 17.07,
                  ),
                ),
                const SizedBox(height: 12),
                ReactiveTextField(
                  key: const Key('RepeatPasswordField'),
                  state: c.repeat,
                  label: 'label_repeat_password'.l10n,
                  obscure: c.obscureRepeat.value,
                  style: style.fonts.titleMedium,
                  onSuffixPressed: c.obscureRepeat.toggle,
                  treatErrorAsStatus: false,
                  trailing: SvgImage.asset(
                    'assets/icons/visible_${c.obscureRepeat.value ? 'off' : 'on'}.svg',
                    width: 17.07,
                  ),
                ),
                const SizedBox(height: 25),
                OutlinedRoundedButton(
                  key: const Key('ChangePasswordButton'),
                  title: Text(
                    'btn_proceed'.l10n,
                    style: c.password.isEmpty.value || c.repeat.isEmpty.value
                        ? style.fonts.bodyMedium
                        : style.fonts.bodyMediumOnPrimary,
                  ),
                  onPressed: c.password.isEmpty.value || c.repeat.isEmpty.value
                      ? null
                      : c.setPassword,
                  color: style.colors.primary,
                ),
              ];
              break;

            case ConfirmLogoutViewStage.success:
              header = ModalPopupHeader(text: 'btn_set_password'.l10n);

              children = [
                Text(
                  'label_password_set'.l10n,
                  style: style.fonts.labelLargeSecondary,
                ),
                const SizedBox(height: 25),
                Center(
                  child: OutlinedRoundedButton(
                    key: const Key('CloseButton'),
                    maxWidth: double.infinity,
                    title: Text(
                      'btn_close'.l10n,
                      style: style.fonts.bodyMediumOnPrimary,
                    ),
                    onPressed: Navigator.of(context).pop,
                    color: style.colors.primary,
                  ),
                ),
              ];
              break;

            default:
              header = ModalPopupHeader(text: 'btn_logout'.l10n);

              children = [
                Center(
                  child: RichText(
                    text: TextSpan(
                      style: style.fonts.titleLargeSecondary,
                      children: [
                        TextSpan(
                          text: 'alert_are_you_sure_want_to_log_out1'.l10n,
                        ),
                        TextSpan(
                          style: style.fonts.titleLarge,
                          text: c.myUser.value?.name?.val ??
                              c.myUser.value?.num.val ??
                              '',
                        ),
                        TextSpan(
                          text: 'alert_are_you_sure_want_to_log_out2'.l10n,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if (c.hasPassword.value) ...[
                  OutlinedRoundedButton(
                    key: const Key('ConfirmLogoutButton'),
                    maxWidth: double.infinity,
                    title: Text(
                      'btn_logout'.l10n,
                      style: style.fonts.titleLargeOnPrimary,
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                    color: style.colors.primary,
                  ),
                ] else ...[
                  RichText(
                    text: TextSpan(
                      style: style.fonts.labelLargeSecondary,
                      children: [
                        TextSpan(text: 'label_password_not_set'.l10n),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedRoundedButton(
                          key: const Key('SetPasswordButton'),
                          maxWidth: double.infinity,
                          title: Text(
                            'btn_set_password'.l10n,
                            style: style.fonts.titleLargeOnPrimary,
                          ),
                          onPressed: () =>
                              c.stage.value = ConfirmLogoutViewStage.password,
                          color: style.colors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedRoundedButton(
                          key: const Key('ConfirmLogoutButton'),
                          maxWidth: double.infinity,
                          title: Text(
                            'btn_logout'.l10n,
                            style: style.fonts.bodyMedium,
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                          color: style.colors.secondaryHighlight,
                        ),
                      )
                    ],
                  ),
                ]
              ];
              break;
          }

          return AnimatedSizeAndFade(
            fadeDuration: const Duration(milliseconds: 250),
            sizeDuration: const Duration(milliseconds: 250),
            child: Scrollbar(
              key: Key('${c.stage.value?.name.capitalizeFirst}Stage'),
              controller: c.scrollController,
              child: ListView(
                controller: c.scrollController,
                shrinkWrap: true,
                children: [
                  header,
                  const SizedBox(height: 12),
                  ...children.map((e) =>
                      Padding(padding: ModalPopup.padding(context), child: e)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}
