// ignore_for_file: implementation_imports, public_member_api_docs
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/src/widgets/toolbar/buttons/alignment/select_alignment_buttons.dart';
import 'package:flutter_quill/src/widgets/toolbar/buttons/arrow_indicated_list_button.dart';
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
enum QuillToolbarOption {
  ///undo
  undo,

  ///redo
  redo,

  ///bold
  bold,

  ///italic
  italic,

  ///underline
  underline,

  ///strikeThrough
  strikeThrough,

  ///Show small button
  smallButton,

  ///textColor
  textColor,

  ///backgroundColor
  backgroundColor,

  ///clearFormat
  clearFormat,

  ///inlineCode
  inlineCode,

  ///alignmentButtons
  alignmentButtons,

  ///headers
  headers,

  ///numberList
  numberList,

  ///bullets
  bullets,

  ///checkBox
  checkBox,

  ///codeBlock
  codeBlock,

  ///indentation
  indentation,

  ///quotes
  quotes,

  ///link
  link,
}

/// Options for Toolbar buttons
enum ToolbarButtons {
  undo,
  redo,
  fontFamily,
  fontSize,
  bold,
  subscript,
  superscript,
  italic,
  small,
  underline,
  strikeThrough,
  inlineCode,
  color,
  backgroundColor,
  clearFormat,
  centerAlignment,
  leftAlignment,
  rightAlignment,
  justifyAlignment,
  direction,
  headerStyle,
  listNumbers,
  listBullets,
  listChecks,
  codeBlock,
  quote,
  indentIncrease,
  indentDecrease,
  link,
  search,
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

  const ZdsQuillToolbar({
    super.configurations,
    required super.child,
    super.key,
  }) : super();

  /// Custom constructor for [ZdsQuillToolbar]
  factory ZdsQuillToolbar.custom({
    required BuildContext context,
    required QuillController controller,
    required Set<QuillToolbarOption> toolbarOptions,
    double? toolbarIconSize,
    String? langCode,
    Color? toolbarColor,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color effectiveToolbarColor = toolbarColor ?? colorScheme.surface;
    return ZdsQuillToolbar.basic(
      context: context,
      toolbarIconSize: toolbarIconSize ?? kDefaultIconSize,
      controller: controller,
      color: effectiveToolbarColor,
      locale: (langCode?.isNotEmpty ?? false) ? Locale(langCode!.substring(0, 2)) : null,
      showUndo: toolbarOptions.contains(QuillToolbarOption.undo),
      showRedo: toolbarOptions.contains(QuillToolbarOption.redo),
      showBoldButton: toolbarOptions.contains(QuillToolbarOption.bold),
      showItalicButton: toolbarOptions.contains(QuillToolbarOption.italic),
      showUnderLineButton: toolbarOptions.contains(QuillToolbarOption.underline),
      showStrikeThrough: toolbarOptions.contains(QuillToolbarOption.strikeThrough),
      showSmallButton: toolbarOptions.contains(QuillToolbarOption.smallButton),
      showColorButton: toolbarOptions.contains(QuillToolbarOption.textColor),
      showBackgroundColorButton: toolbarOptions.contains(QuillToolbarOption.backgroundColor),
      showClearFormat: toolbarOptions.contains(QuillToolbarOption.clearFormat),
      showInlineCode: toolbarOptions.contains(QuillToolbarOption.inlineCode),
      showAlignmentButtons: toolbarOptions.contains(QuillToolbarOption.alignmentButtons),
      showHeaderStyle: toolbarOptions.contains(QuillToolbarOption.headers),
      showListNumbers: toolbarOptions.contains(QuillToolbarOption.numberList),
      showListBullets: toolbarOptions.contains(QuillToolbarOption.bullets),
      showListCheck: toolbarOptions.contains(QuillToolbarOption.checkBox),
      showIndent: toolbarOptions.contains(QuillToolbarOption.indentation),
      showQuote: toolbarOptions.contains(QuillToolbarOption.quotes),
      showLink: toolbarOptions.contains(QuillToolbarOption.link),
      linkRegExp: RegExp(r'(http|ftp|https)://[\w-]+(\.[\w-]+)+([\w.,@?^=%&amp;:/~+#-]*[\w@?^=%&amp;/~+#-])?'),
      showSubscript: false,
      showSuperscript: false,
      showSearchButton: false,
      multiRowsDisplay: false,
      iconTheme: QuillIconTheme(
        iconButtonUnselectedData: IconButtonData(
          color: effectiveToolbarColor.onColor,
        ),
        iconButtonSelectedData: IconButtonData(
          color: colorScheme.secondary,
        ),
      ),
    );
  }

  /// Basic constructor for ZdsQuillToolbar
  factory ZdsQuillToolbar.basic({
    required BuildContext context,
    required QuillController controller,
    Axis axis = Axis.horizontal,
    double toolbarIconSize = kDefaultIconSize,
    double toolbarSectionSpacing = kToolbarSectionSpacing,
    WrapAlignment toolbarIconAlignment = WrapAlignment.center,
    WrapCrossAlignment toolbarIconCrossAlignment = WrapCrossAlignment.center,
    bool multiRowsDisplay = true,
    bool showDividers = true,
    bool showBoldButton = true,
    bool showItalicButton = true,
    bool showSmallButton = false,
    bool showUnderLineButton = true,
    bool showStrikeThrough = true,
    bool showInlineCode = true,
    bool showColorButton = true,
    bool showBackgroundColorButton = true,
    bool showClearFormat = true,
    bool showAlignmentButtons = false,
    bool showLeftAlignment = true,
    bool showCenterAlignment = true,
    bool showRightAlignment = true,
    bool showJustifyAlignment = true,
    bool showHeaderStyle = true,
    bool showListNumbers = true,
    bool showListBullets = true,
    bool showListCheck = true,
    bool showQuote = true,
    bool showIndent = true,
    bool showLink = true,
    bool showUndo = true,
    bool showRedo = true,
    bool showDirection = false,
    bool showSearchButton = true,
    bool showSubscript = true,
    bool showSuperscript = true,
    bool showCodeBlock = false,
    List<QuillToolbarCustomButton> customButtons = const <QuillToolbarCustomButton>[],

    /// Toolbar items to display for controls of embed blocks
    List<EmbedButtonBuilder>? embedButtons,

    ///The theme to use for the icons in the toolbar, uses type [QuillIconTheme]
    QuillIconTheme? iconTheme,

    ///The theme to use for the theming of the [LinkDialog()],
    ///shown when embedding an image, for example
    QuillDialogTheme? dialogTheme,

    /// Callback to be called after any button on the toolbar is pressed.
    /// Is called after whatever logic the button performs has run.
    VoidCallback? afterButtonPressed,

    ///Map of tooltips for toolbar  buttons
    ///
    ///The example is:
    ///```dart
    /// tooltips = <ToolbarButtons, String>{
    ///   ToolbarButtons.undo: 'Undo',
    ///   ToolbarButtons.redo: 'Redo',
    /// }
    ///
    ///```
    ///
    /// To disable tooltips just pass empty map as well.
    Map<ToolbarButtons, String>? tooltips,

    /// The locale to use for the editor toolbar, defaults to system locale
    /// More at https://github.com/singerdmx/flutter-quill#translation
    Locale? locale,

    /// The color of the toolbar
    Color? color,

    /// The color of the toolbar section divider
    Color? sectionDividerColor,

    /// The space occupied by toolbar divider
    double? sectionDividerSpace,

    /// Validate the legitimacy of hyperlinks
    RegExp? linkRegExp,
    LinkDialogAction? linkDialogAction,
    Key? key,
  }) {
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
      showQuote || showIndent,
      showLink || showSearchButton,
    ];

    final componentString = ComponentStrings.of(context);
    final configurations = QuillSimpleToolbarConfigurations(
      controller: controller,
      axis: axis,
      toolbarSize: toolbarIconSize * 3,
      color: color,
      toolbarSectionSpacing: toolbarSectionSpacing,
      toolbarIconAlignment: toolbarIconAlignment,
      toolbarIconCrossAlignment: toolbarIconCrossAlignment,
      multiRowsDisplay: multiRowsDisplay,
    );
    iconTheme ??= QuillIconTheme(
      iconButtonSelectedData: IconButtonData(
        iconSize: toolbarIconSize,
        alignment: Alignment.topCenter,
      ),
      iconButtonUnselectedData: IconButtonData(iconSize: toolbarIconSize),
    );

    return ZdsQuillToolbar(
      configurations: QuillToolbarConfigurations(
        sharedConfigurations: QuillSharedConfigurations(
          locale: locale,
        ),
      ),
      key: key,
      child: Builder(
        builder: (context) {
          //  default button tooltips
          final buttonTooltips = tooltips ??
              <ToolbarButtons, String>{
                ToolbarButtons.undo: componentString.get('STR_UNDO', context.loc.undo),
                ToolbarButtons.redo: componentString.get('REDO', context.loc.redo),
                ToolbarButtons.fontFamily: componentString.get('FONT_FAMILY', context.loc.fontFamily),
                ToolbarButtons.fontSize: componentString.get('FONT_SIZE', context.loc.fontSize),
                ToolbarButtons.bold: componentString.get('BOLD', context.loc.bold),
                ToolbarButtons.subscript: componentString.get('SUBSCRIPT', context.loc.subscript),
                ToolbarButtons.superscript: componentString.get('SUPERSCRIPT', context.loc.superscript),
                ToolbarButtons.italic: componentString.get('ITALIC', context.loc.italic),
                ToolbarButtons.small: componentString.get('SMALL', context.loc.small),
                ToolbarButtons.underline: componentString.get('UNDERLINE', context.loc.underline),
                ToolbarButtons.strikeThrough: componentString.get('STRIKE_THROUGH', context.loc.strikeThrough),
                ToolbarButtons.inlineCode: componentString.get('INLINE_CODE', context.loc.inlineCode),
                ToolbarButtons.color: componentString.get('FONT_COLOR', context.loc.fontColor),
                ToolbarButtons.backgroundColor: componentString.get('BACKGROUND_COLOR', context.loc.backgroundColor),
                ToolbarButtons.clearFormat: componentString.get('CLEAR_FORMAT', context.loc.clearFormat),
                ToolbarButtons.leftAlignment: componentString.get('ALIGN_LEFT', context.loc.alignLeft),
                ToolbarButtons.centerAlignment: componentString.get('ALIGN_CENTER', context.loc.alignCenter),
                ToolbarButtons.rightAlignment: componentString.get('ALIGN_RIGHT', context.loc.alignRight),
                ToolbarButtons.justifyAlignment: componentString.get('JUSTIFY_WIDTH', context.loc.justifyWinWidth),
                ToolbarButtons.direction: componentString.get('TEXT_DIRECTION', context.loc.textDirection),
                ToolbarButtons.headerStyle: componentString.get('HEADER_STYLE', context.loc.headerStyle),
                ToolbarButtons.listNumbers: componentString.get('NUMBERED_LIST', context.loc.numberedList),
                ToolbarButtons.listBullets: componentString.get('BULLET_LIST', context.loc.bulletList),
                ToolbarButtons.listChecks: componentString.get('CHECKED_LIST', context.loc.checkedList),
                ToolbarButtons.codeBlock: componentString.get('CODE_BLOCK', context.loc.codeBlock),
                ToolbarButtons.quote: componentString.get('EDITOR_QUOTE', context.loc.quote),
                ToolbarButtons.indentIncrease: componentString.get('INCREASE_INDENT', context.loc.increaseIndent),
                ToolbarButtons.indentDecrease: componentString.get('DECREASE_INDENT', context.loc.decreaseIndent),
                ToolbarButtons.link: componentString.get('INSERT_URL', context.loc.link),
                ToolbarButtons.search: componentString.get('SEARCH', context.loc.search),
              };

          return Container(
            decoration: configurations.decoration ?? BoxDecoration(color: configurations.color),
            constraints: BoxConstraints.tightFor(
              height: configurations.axis == Axis.horizontal ? configurations.toolbarSize : null,
              width: configurations.axis == Axis.vertical ? configurations.toolbarSize : null,
            ),
            child: Material(
              color: configurations.color,
              child: QuillToolbarArrowIndicatedButtonList(
                axis: Axis.horizontal,
                buttons: [
                  if (showUndo)
                    QuillToolbarHistoryButton(
                      controller: controller,
                      isUndo: true,
                      options: QuillToolbarHistoryButtonOptions(
                        iconButtonFactor: toolbarSectionSpacing,
                        iconData: Icons.undo_outlined,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.undo],
                      ),
                    ),
                  if (showRedo) ...<Widget>[
                    QuillToolbarHistoryButton(
                      controller: controller,
                      isUndo: false,
                      options: QuillToolbarHistoryButtonOptions(
                        iconData: Icons.redo_outlined,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.redo],
                      ),
                    ),
                    if (showDividers) QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  ],
                  if (showHeaderStyle) ...<Widget>[
                    QuillToolbarSelectHeaderStyleButtons(
                      controller: controller,
                      options: QuillToolbarSelectHeaderStyleButtonsOptions(
                        tooltip: buttonTooltips[ToolbarButtons.headerStyle],
                        axis: axis,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                    if (showDividers) QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  ],
                  if (showBoldButton)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.bold,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_bold,
                        iconSize: toolbarIconSize,
                        tooltip: buttonTooltips[ToolbarButtons.bold],
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showSubscript)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.subscript,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.subscript,
                        iconSize: toolbarIconSize,
                        tooltip: buttonTooltips[ToolbarButtons.subscript],
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showSuperscript)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.superscript,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.superscript,
                        iconSize: toolbarIconSize,
                        tooltip: buttonTooltips[ToolbarButtons.superscript],
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showItalicButton)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.italic,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_italic,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        tooltip: buttonTooltips[ToolbarButtons.italic],
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showUnderLineButton)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.underline,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_underline,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.underline],
                      ),
                    ),
                  if (showStrikeThrough)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.strikeThrough,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_strikethrough,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.strikeThrough],
                      ),
                    ),
                  if (showSmallButton)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.small,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_size,
                        iconSize: toolbarIconSize,
                        tooltip: buttonTooltips[ToolbarButtons.small],
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showInlineCode)
                    Column(
                      children: [
                        QuillToolbarToggleStyleButton(
                          attribute: Attribute.inlineCode,
                          controller: controller,
                          options: QuillToolbarToggleStyleButtonOptions(
                            iconData: Icons.code,
                            iconSize: toolbarIconSize,
                            iconTheme: iconTheme,
                            afterButtonPressed: afterButtonPressed,
                            tooltip: buttonTooltips[ToolbarButtons.inlineCode],
                          ),
                        ),
                      ],
                    ),
                  if (showDividers) QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  if (showColorButton)
                    ZdsQuillToolbarColorButton(
                      controller: controller,
                      isBackground: false,
                      options: QuillToolbarColorButtonOptions(
                        iconData: Icons.color_lens,
                        iconSize: toolbarIconSize,
                        tooltip: buttonTooltips[ToolbarButtons.color],
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showBackgroundColorButton)
                    ZdsQuillToolbarColorButton(
                      controller: controller,
                      isBackground: true,
                      options: QuillToolbarColorButtonOptions(
                        iconData: Icons.format_color_fill,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.backgroundColor],
                      ),
                    ),
                  if (showClearFormat)
                    QuillToolbarClearFormatButton(
                      controller: controller,
                      options: QuillToolbarBaseButtonOptions(
                        iconData: Icons.format_clear,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.clearFormat],
                      ),
                    ),
                  if (embedButtons != null)
                    for (final EmbedButtonBuilder builder in embedButtons)
                      builder(controller, toolbarIconSize, iconTheme, dialogTheme),
                  if (showDividers &&
                      isButtonGroupShown[0] &&
                      (isButtonGroupShown[1] ||
                          isButtonGroupShown[2] ||
                          isButtonGroupShown[3] ||
                          isButtonGroupShown[4] ||
                          isButtonGroupShown[5]))
                    QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  if (showAlignmentButtons)
                    QuillToolbarSelectAlignmentButtons(
                      controller: controller,
                      options: QuillToolbarSelectAlignmentButtonOptions(
                        tooltips: QuillSelectAlignmentValues(
                          leftAlignment: buttonTooltips[ToolbarButtons.leftAlignment] ?? context.loc.alignLeft,
                          centerAlignment: buttonTooltips[ToolbarButtons.centerAlignment] ?? context.loc.alignCenter,
                          rightAlignment: buttonTooltips[ToolbarButtons.rightAlignment] ?? context.loc.alignRight,
                          justifyAlignment:
                              buttonTooltips[ToolbarButtons.justifyAlignment] ?? context.loc.justifyWinWidth,
                        ),
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        showLeftAlignment: showLeftAlignment,
                        showCenterAlignment: showCenterAlignment,
                        showRightAlignment: showRightAlignment,
                        showJustifyAlignment: showJustifyAlignment,
                        afterButtonPressed: afterButtonPressed,
                      ),
                    ),
                  if (showDirection)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.rtl,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_textdirection_r_to_l,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.direction],
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
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.listNumbers],
                      ),
                    ),
                  if (showListBullets)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.ul,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.format_list_bulleted,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.listBullets],
                      ),
                    ),
                  if (showListCheck)
                    QuillToolbarToggleCheckListButton(
                      controller: controller,
                      options: QuillToolbarToggleCheckListButtonOptions(
                        iconData: Icons.check_box,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.listChecks],
                      ),
                    ),
                  if (showCodeBlock)
                    QuillToolbarToggleStyleButton(
                      attribute: Attribute.codeBlock,
                      controller: controller,
                      options: QuillToolbarToggleStyleButtonOptions(
                        iconData: Icons.code,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.codeBlock],
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
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.quote],
                      ),
                    ),
                  if (showIndent)
                    QuillToolbarIndentButton(
                      controller: controller,
                      isIncrease: true,
                      options: QuillToolbarIndentButtonOptions(
                        iconData: Icons.format_indent_increase,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.indentIncrease],
                      ),
                    ),
                  if (showIndent)
                    QuillToolbarIndentButton(
                      controller: controller,
                      isIncrease: false,
                      options: QuillToolbarIndentButtonOptions(
                        iconData: Icons.format_indent_decrease,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.indentDecrease],
                      ),
                    ),
                  if (showDividers && isButtonGroupShown[4] && isButtonGroupShown[5])
                    QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  if (showLink)
                    QuillToolbarLinkStyleButton(
                      controller: controller,
                      options: QuillToolbarLinkStyleButtonOptions(
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        dialogTheme: dialogTheme,
                        afterButtonPressed: afterButtonPressed,
                        linkRegExp: linkRegExp,
                        linkDialogAction: linkDialogAction,
                        tooltip: buttonTooltips[ToolbarButtons.link],
                      ),
                    ),
                  if (showSearchButton)
                    QuillToolbarSearchButton(
                      controller: controller,
                      options: QuillToolbarSearchButtonOptions(
                        iconData: Icons.search,
                        iconSize: toolbarIconSize,
                        iconTheme: iconTheme,
                        dialogTheme: dialogTheme,
                        afterButtonPressed: afterButtonPressed,
                        tooltip: buttonTooltips[ToolbarButtons.search],
                      ),
                    ),
                  if (customButtons.isNotEmpty)
                    if (showDividers) QuillToolbarDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
                  for (final customButton in customButtons)
                    QuillToolbarCustomButton(
                      options: customButton.options,
                      controller: controller,
                    ),
                  for (final customButton in configurations.customButtons)
                    QuillToolbarCustomButton(
                      options: customButton,
                      controller: controller,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
