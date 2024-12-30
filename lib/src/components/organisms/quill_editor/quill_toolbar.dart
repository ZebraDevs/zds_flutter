// ignore_for_file: implementation_imports

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

import '../../../../zds_flutter.dart';
import 'color_button.dart';

/// enum for toolbar position
///
/// above or below editor
enum QuillToolbarPosition {
  /// toolbar position at top
  top,

  /// toolbar position at bottom
  bottom
}

/// toolbar options
/// Enum representing the various options available in the Quill toolbar.
enum QuillToolbarOption {
  /// Option to undo the last action.
  undo,

  /// Option to redo the last undone action.
  redo,

  /// Option to apply bold formatting to the selected text.
  bold,

  /// Option to apply italic formatting to the selected text.
  italic,

  /// Option to apply underline formatting to the selected text.
  underline,

  /// Option to apply strikethrough formatting to the selected text.
  strikeThrough,

  /// Option to show a small button on the toolbar.
  smallButton,

  /// Option to change the color of the selected text.
  textColor,

  /// Option to change the background color of the selected text.
  backgroundColor,

  /// Option to clear all formatting from the selected text.
  clearFormat,

  /// Option to apply inline code formatting to the selected text.
  inlineCode,

  /// Option to apply header styles to the selected text.
  headers,

  /// Option to create a numbered list.
  numberList,

  /// Option to create a bulleted list.
  bullets,

  /// Option to add a checkbox to the text.
  checkBox,

  /// Option to create a code block.
  codeBlock,

  /// Option to apply blockquote formatting to the selected text.
  quotes,

  /// Option to add a hyperlink to the selected text.
  link,

  /// Option to apply subscript formatting to the selected text.
  subscript,

  /// Option to apply superscript formatting to the selected text.
  superscript,

  /// Option to apply small text formatting to the selected text.
  small,

  /// Option to change the text color.
  color,

  /// Option to align the text to the center.
  centerAlignment,

  /// Option to align the text to the left.
  leftAlignment,

  /// Option to align the text to the right.
  rightAlignment,

  /// Option to justify the text alignment.
  justifyAlignment,

  /// Option to change the text direction.
  direction,

  /// Option to apply header styles to the selected text.
  headerStyle,

  /// Option to increase the indentation of the selected text.
  indentIncrease,

  /// Option to decrease the indentation of the selected text.
  indentDecrease,
}

/// The default size of the icon of a button.
const double kDefaultIconSize = 18;

/// The factor of how much larger the button is in relation to the icon.
const double kIconButtonFactor = 1.77;

/// The horizontal margin between the contents of each toolbar section.
const double kToolbarSectionSpacing = 4;

/// Toolbar
class ZdsQuillToolbar extends QuillToolbar {
  ///Constructor

  const ZdsQuillToolbar._({
    super.configurations,
    required super.child,
    super.key,
  }) : super();

  /// Basic constructor for ZdsQuillToolbar
  /// Basic constructor for ZdsQuillToolbar.
  factory ZdsQuillToolbar.basic({
    /// The [BuildContext] in which the toolbar will be built.
    required BuildContext context,

    /// The [QuillController] that controls the Quill editor.
    required QuillController controller,

    /// The set of options to be displayed in the toolbar.
    required Set<QuillToolbarOption> toolbarOptions,

    /// The key for the toolbar.
    Key? key,

    /// The position of the toolbar, defaults to [QuillToolbarPosition.bottom].
    QuillToolbarPosition position = QuillToolbarPosition.bottom,

    /// The axis of the toolbar, defaults to [Axis.horizontal].
    Axis axis = Axis.horizontal,

    /// The size of the icons in the toolbar.
    double? toolbarIconSize,

    /// The spacing between sections in the toolbar, defaults to [kToolbarSectionSpacing].
    double toolbarSectionSpacing = kToolbarSectionSpacing,

    /// Whether to show dividers between toolbar sections, defaults to true.
    bool showDividers = true,

    /// Custom buttons to be added to the toolbar.
    List<QuillToolbarCustomButton> customButtons = const <QuillToolbarCustomButton>[],

    /// Toolbar items to display for controls of embed blocks.
    List<EmbedButtonBuilder>? embedButtons,

    /// The theme to use for the icons in the toolbar, uses type [QuillIconTheme].
    QuillIconTheme? iconTheme,

    /// The theme to use for the theming of the [LinkDialog()], shown when embedding an image, for example.
    QuillDialogTheme? dialogTheme,

    /// Callback to be called after any button on the toolbar is pressed.
    /// Is called after whatever logic the button performs has run.
    VoidCallback? afterButtonPressed,

    /// Map of tooltips for toolbar buttons.
    ///
    /// The example is:
    /// ```dart
    /// tooltips = <ToolbarButtons, String>{
    ///   ToolbarButtons.undo: 'Undo',
    ///   ToolbarButtons.redo: 'Redo',
    /// }
    /// ```
    ///
    /// To disable tooltips just pass an empty map as well.
    Map<QuillToolbarPosition, String>? tooltips,

    /// The locale to use for the editor toolbar, defaults to system locale.
    /// More at https://github.com/singerdmx/flutter-quill#translation
    Locale? locale,

    /// The color of the toolbar.
    Color? color,

    /// The color of the toolbar section divider.
    Color? sectionDividerColor,

    /// The space occupied by the toolbar divider.
    double? sectionDividerSpace,

    /// Regular expression to validate the legitimacy of hyperlinks.
    RegExp? linkRegExp,

    /// Action to be performed for the link dialog.
    LinkDialogAction? linkDialogAction,
  }) {
    final showUndo = toolbarOptions.contains(QuillToolbarOption.undo);
    final showRedo = toolbarOptions.contains(QuillToolbarOption.redo);
    final showBoldButton = toolbarOptions.contains(QuillToolbarOption.bold);
    final showItalicButton = toolbarOptions.contains(QuillToolbarOption.italic);
    final showUnderLineButton = toolbarOptions.contains(QuillToolbarOption.underline);
    final showStrikeThrough = toolbarOptions.contains(QuillToolbarOption.strikeThrough);
    final showSmallButton = toolbarOptions.contains(QuillToolbarOption.smallButton);
    final showColorButton = toolbarOptions.contains(QuillToolbarOption.textColor);
    final showCodeBlock = toolbarOptions.contains(QuillToolbarOption.codeBlock);
    final showBackgroundColorButton = toolbarOptions.contains(QuillToolbarOption.backgroundColor);
    final showClearFormat = toolbarOptions.contains(QuillToolbarOption.clearFormat);
    final showInlineCode = toolbarOptions.contains(QuillToolbarOption.inlineCode);
    final showIndentDecrease = toolbarOptions.contains(QuillToolbarOption.indentDecrease);
    final showIndentIncrease = toolbarOptions.contains(QuillToolbarOption.indentIncrease);
    final showHeaderStyle = toolbarOptions.contains(QuillToolbarOption.headers);
    final showListNumbers = toolbarOptions.contains(QuillToolbarOption.numberList);
    final showListBullets = toolbarOptions.contains(QuillToolbarOption.bullets);
    final showListCheck = toolbarOptions.contains(QuillToolbarOption.checkBox);
    final showQuote = toolbarOptions.contains(QuillToolbarOption.quotes);
    final showLink = toolbarOptions.contains(QuillToolbarOption.link);

    final showLeftAlignment = toolbarOptions.contains(QuillToolbarOption.leftAlignment);
    final showCenterAlignment = toolbarOptions.contains(QuillToolbarOption.centerAlignment);
    final showRightAlignment = toolbarOptions.contains(QuillToolbarOption.rightAlignment);
    final showJustifyAlignment = toolbarOptions.contains(QuillToolbarOption.justifyAlignment);

    final showDirection = toolbarOptions.contains(QuillToolbarOption.direction);
    final showSubscript = toolbarOptions.contains(QuillToolbarOption.subscript);
    final showSuperscript = toolbarOptions.contains(QuillToolbarOption.superscript);

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? colorScheme.surface;
    final effectiveIconSize = toolbarIconSize ?? kDefaultIconSize;
    final effectiveIconTheme = iconTheme ??
        QuillIconTheme(
          iconButtonUnselectedData: IconButtonData(color: effectiveColor.onColor),
          iconButtonSelectedData: IconButtonData(color: colorScheme.secondary),
        );

    final List<bool> isButtonGroupShown = <bool>[
      showBoldButton ||
          showItalicButton ||
          showSmallButton ||
          showUnderLineButton ||
          showStrikeThrough ||
          showInlineCode ||
          showColorButton ||
          showBackgroundColorButton ||
          showClearFormat ||
          embedButtons != null && embedButtons.isNotEmpty,
      showLeftAlignment || showCenterAlignment || showRightAlignment || showJustifyAlignment || showDirection,
      showHeaderStyle,
      showListNumbers || showListBullets || showListCheck,
      showQuote || showIndentDecrease || showIndentIncrease,
      showLink,
    ];

    final strings = ComponentStrings.of(context);
    return ZdsQuillToolbar._(
      configurations: QuillToolbarConfigurations(
        sharedConfigurations: QuillSharedConfigurations(
          locale: locale ?? strings.locale,
        ),
      ),
      key: key,
      child: TooltipTheme(
        data: TooltipThemeData(preferBelow: position == QuillToolbarPosition.top),
        child: Builder(
          builder: (context) {
            //  default button tooltips
            final buttonTooltips = tooltips ??
                <QuillToolbarOption, String>{
                  QuillToolbarOption.undo: strings.get('STR_UNDO', context.loc.undo),
                  QuillToolbarOption.redo: strings.get('REDO', context.loc.redo),
                  QuillToolbarOption.bold: strings.get('BOLD', context.loc.bold),
                  QuillToolbarOption.subscript: strings.get('SUBSCRIPT', context.loc.subscript),
                  QuillToolbarOption.superscript: strings.get('SUPERSCRIPT', context.loc.superscript),
                  QuillToolbarOption.italic: strings.get('ITALIC', context.loc.italic),
                  QuillToolbarOption.small: strings.get('SMALL', context.loc.small),
                  QuillToolbarOption.underline: strings.get('UNDERLINE', context.loc.underline),
                  QuillToolbarOption.strikeThrough: strings.get('STRIKE_THROUGH', context.loc.strikeThrough),
                  QuillToolbarOption.inlineCode: strings.get('INLINE_CODE', context.loc.inlineCode),
                  QuillToolbarOption.color: strings.get('FONT_COLOR', context.loc.fontColor),
                  QuillToolbarOption.backgroundColor: strings.get('BACKGROUND_COLOR', context.loc.backgroundColor),
                  QuillToolbarOption.clearFormat: strings.get('CLEAR_FORMAT', context.loc.clearFormat),
                  QuillToolbarOption.leftAlignment: strings.get('ALIGN_LEFT', context.loc.alignLeft),
                  QuillToolbarOption.centerAlignment: strings.get('ALIGN_CENTER', context.loc.alignCenter),
                  QuillToolbarOption.rightAlignment: strings.get('ALIGN_RIGHT', context.loc.alignRight),
                  QuillToolbarOption.justifyAlignment: strings.get('JUSTIFY_WIDTH', context.loc.justifyWinWidth),
                  QuillToolbarOption.direction: strings.get('TEXT_DIRECTION', context.loc.textDirection),
                  QuillToolbarOption.headerStyle: strings.get('HEADER_STYLE', context.loc.headerStyle),
                  QuillToolbarOption.numberList: strings.get('NUMBERED_LIST', context.loc.numberedList),
                  QuillToolbarOption.bullets: strings.get('BULLET_LIST', context.loc.bulletList),
                  QuillToolbarOption.checkBox: strings.get('CHECKED_LIST', context.loc.checkedList),
                  QuillToolbarOption.codeBlock: strings.get('CODE_BLOCK', context.loc.codeBlock),
                  QuillToolbarOption.quotes: strings.get('EDITOR_QUOTE', context.loc.quote),
                  QuillToolbarOption.indentIncrease: strings.get('INCREASE_INDENT', context.loc.increaseIndent),
                  QuillToolbarOption.indentDecrease: strings.get('DECREASE_INDENT', context.loc.decreaseIndent),
                  QuillToolbarOption.link: strings.get('INSERT_URL', context.loc.link),
                };

            return Container(
              decoration: BoxDecoration(color: effectiveColor),
              constraints: BoxConstraints.tightFor(
                height: axis == Axis.horizontal ? effectiveIconSize * 3 : null,
                width: axis == Axis.vertical ? effectiveIconSize * 3 : null,
              ),
              child: Material(
                color: effectiveColor,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if (showUndo)
                        QuillToolbarHistoryButton(
                          controller: controller,
                          isUndo: true,
                          options: QuillToolbarHistoryButtonOptions(
                            iconButtonFactor: toolbarSectionSpacing,
                            iconData: Icons.undo_outlined,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.undo],
                          ),
                        ),
                      if (showRedo) ...<Widget>[
                        QuillToolbarHistoryButton(
                          controller: controller,
                          isUndo: false,
                          options: QuillToolbarHistoryButtonOptions(
                            iconData: Icons.redo_outlined,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.redo],
                          ),
                        ),
                        if (showDividers)
                          QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      ],
                      if (showHeaderStyle) ...<Widget>[
                        QuillToolbarSelectHeaderStyleButtons(
                          controller: controller,
                          options: QuillToolbarSelectHeaderStyleButtonsOptions(
                            tooltip: buttonTooltips[QuillToolbarOption.headerStyle],
                            axis: axis,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                        if (showDividers)
                          QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      ],
                      if (showBoldButton)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.bold,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_bold,
                            iconSize: effectiveIconSize,
                            tooltip: buttonTooltips[QuillToolbarOption.bold],
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showSubscript)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.subscript,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.subscript,
                            iconSize: effectiveIconSize,
                            tooltip: buttonTooltips[QuillToolbarOption.subscript],
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showSuperscript)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.superscript,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.superscript,
                            iconSize: effectiveIconSize,
                            tooltip: buttonTooltips[QuillToolbarOption.superscript],
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showItalicButton)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.italic,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_italic,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            tooltip: buttonTooltips[QuillToolbarOption.italic],
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showUnderLineButton)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.underline,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_underline,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.underline],
                          ),
                        ),
                      if (showStrikeThrough)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.strikeThrough,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_strikethrough,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.strikeThrough],
                          ),
                        ),
                      if (showSmallButton)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.small,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_size,
                            iconSize: effectiveIconSize,
                            tooltip: buttonTooltips[QuillToolbarOption.small],
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showInlineCode)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.inlineCode,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.code,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.inlineCode],
                          ),
                        ),
                      if (showDividers)
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showColorButton)
                        ZdsQuillToolbarColorButton(
                          controller: controller,
                          isBackground: false,
                          options: QuillToolbarColorButtonOptions(
                            iconData: Icons.color_lens,
                            iconSize: effectiveIconSize,
                            tooltip: buttonTooltips[QuillToolbarOption.color],
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                          ),
                        ),
                      if (showBackgroundColorButton)
                        ZdsQuillToolbarColorButton(
                          controller: controller,
                          isBackground: true,
                          options: QuillToolbarColorButtonOptions(
                            iconData: Icons.format_color_fill,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.backgroundColor],
                          ),
                        ),
                      if (showClearFormat)
                        QuillToolbarClearFormatButton(
                          controller: controller,
                          options: QuillToolbarBaseButtonOptions(
                            iconData: Icons.format_clear,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.clearFormat],
                          ),
                        ),
                      if (embedButtons != null)
                        for (final EmbedButtonBuilder builder in embedButtons)
                          builder(controller, effectiveIconSize, effectiveIconTheme, dialogTheme),
                      if (showDividers &&
                          isButtonGroupShown[0] &&
                          (isButtonGroupShown[1] ||
                              isButtonGroupShown[2] ||
                              isButtonGroupShown[3] ||
                              isButtonGroupShown[4] ||
                              isButtonGroupShown[5]))
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showLeftAlignment)
                        QuillToolbarToggleStyleButton(
                          controller: controller,
                          attribute: Attribute.leftAlignment,
                        ),
                      if (showCenterAlignment)
                        QuillToolbarToggleStyleButton(
                          controller: controller,
                          attribute: Attribute.centerAlignment,
                        ),
                      if (showRightAlignment)
                        QuillToolbarToggleStyleButton(
                          controller: controller,
                          attribute: Attribute.rightAlignment,
                        ),
                      if (showJustifyAlignment)
                        QuillToolbarToggleStyleButton(
                          controller: controller,
                          attribute: Attribute.justifyAlignment,
                        ),
                      if (showDirection)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.rtl,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_textdirection_r_to_l,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.direction],
                          ),
                        ),
                      if (showDividers &&
                          isButtonGroupShown[1] &&
                          (isButtonGroupShown[2] ||
                              isButtonGroupShown[3] ||
                              isButtonGroupShown[4] ||
                              isButtonGroupShown[5]))
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showDividers &&
                          showHeaderStyle &&
                          isButtonGroupShown[2] &&
                          (isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showListNumbers)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.ol,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_list_numbered,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.numberList],
                          ),
                        ),
                      if (showListBullets)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.ul,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_list_bulleted,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.bullets],
                          ),
                        ),
                      if (showListCheck)
                        QuillToolbarToggleCheckListButton(
                          controller: controller,
                          options: QuillToolbarToggleCheckListButtonOptions(
                            iconData: Icons.check_box,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.checkBox],
                          ),
                        ),
                      if (showCodeBlock)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.codeBlock,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.code,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.codeBlock],
                          ),
                        ),
                      if (showDividers && isButtonGroupShown[3] && (isButtonGroupShown[4] || isButtonGroupShown[5]))
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showQuote)
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.blockQuote,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.format_quote,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.quotes],
                          ),
                        ),
                      if (showIndentIncrease)
                        QuillToolbarIndentButton(
                          controller: controller,
                          isIncrease: true,
                          options: QuillToolbarIndentButtonOptions(
                            iconData: Icons.format_indent_increase,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.indentIncrease],
                          ),
                        ),
                      if (showIndentDecrease)
                        QuillToolbarIndentButton(
                          controller: controller,
                          isIncrease: false,
                          options: QuillToolbarIndentButtonOptions(
                            iconData: Icons.format_indent_decrease,
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[QuillToolbarOption.indentDecrease],
                          ),
                        ),
                      if (showDividers && isButtonGroupShown[4] && isButtonGroupShown[5])
                        QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      if (showLink)
                        QuillToolbarLinkStyleButton(
                          controller: controller,
                          options: QuillToolbarLinkStyleButtonOptions(
                            iconSize: effectiveIconSize,
                            iconTheme: effectiveIconTheme,
                            dialogTheme: dialogTheme,
                            afterButtonPressed: afterButtonPressed,
                            linkRegExp: linkRegExp ??
                                RegExp(
                                  r'(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?',
                                ),
                            linkDialogAction: linkDialogAction,
                            tooltip: buttonTooltips[QuillToolbarOption.link],
                          ),
                        ),
                      if (customButtons.isNotEmpty)
                        if (showDividers)
                          QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                      for (final customButton in customButtons)
                        QuillToolbarCustomButton(
                          options: customButton.options,
                          controller: controller,
                        ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
