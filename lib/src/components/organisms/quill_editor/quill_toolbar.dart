import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/translations.dart';

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

  ///fontFamily
  fontFamily,

  ///fontSize
  fontSize,

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
    super.children = const <Widget>[],
    super.axis,
    super.toolbarSize,
    super.toolbarSectionSpacing,
    super.toolbarIconAlignment,
    super.toolbarIconCrossAlignment,
    super.multiRowsDisplay,
    super.color,
    super.customButtons,
    super.locale,
    super.afterButtonPressed,
    super.sectionDividerColor,
    super.sectionDividerSpace,
    super.linkDialogAction,
    super.key,
  }) : super();

  /// Custom constructor for [ZdsQuillToolbar]
  factory ZdsQuillToolbar.custom({
    required BuildContext context,
    required QuillController controller,
    required Set<QuillToolbarOption> toolbarOptions,
    double? toolbarIconSize,
    String? langCode,
    Color? color,
  }) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    return ZdsQuillToolbar.basic(
      toolbarIconSize: toolbarIconSize ?? 24,
      controller: controller,
      color: color,
      locale: (langCode?.isNotEmpty ?? false) ? Locale(langCode!.substring(0, 2)) : null,
      showUndo: toolbarOptions.contains(QuillToolbarOption.undo),
      showRedo: toolbarOptions.contains(QuillToolbarOption.redo),
      showFontFamily: toolbarOptions.contains(QuillToolbarOption.fontFamily),
      showFontSize: toolbarOptions.contains(QuillToolbarOption.fontSize),
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
      showCodeBlock: toolbarOptions.contains(QuillToolbarOption.codeBlock),
      showIndent: toolbarOptions.contains(QuillToolbarOption.indentation),
      showQuote: toolbarOptions.contains(QuillToolbarOption.quotes),
      showLink: toolbarOptions.contains(QuillToolbarOption.link),
      showSubscript: false,
      showSuperscript: false,
      showSearchButton: false,
      multiRowsDisplay: false,
      iconTheme: QuillIconTheme(
        iconSelectedFillColor: theme.secondary,
        iconUnselectedFillColor: theme.surface,
        iconUnselectedColor: theme.onSurface,
      ),
    );
  }

  /// Basic constructor for ZdsQuillToolbar
  factory ZdsQuillToolbar.basic({
    required QuillController controller,
    Axis axis = Axis.horizontal,
    double toolbarIconSize = kDefaultIconSize,
    double toolbarSectionSpacing = kToolbarSectionSpacing,
    WrapAlignment toolbarIconAlignment = WrapAlignment.center,
    WrapCrossAlignment toolbarIconCrossAlignment = WrapCrossAlignment.center,
    bool multiRowsDisplay = true,
    bool showDividers = true,
    bool showFontFamily = true,
    bool showFontSize = true,
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
    bool showCodeBlock = true,
    bool showQuote = true,
    bool showIndent = true,
    bool showLink = true,
    bool showUndo = true,
    bool showRedo = true,
    bool showDirection = false,
    bool showSearchButton = true,
    bool showSubscript = true,
    bool showSuperscript = true,
    List<QuillCustomButton> customButtons = const <QuillCustomButton>[],

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
      showFontFamily ||
          showFontSize ||
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
      showListNumbers || showListBullets || showListCheck || showCodeBlock,
      showQuote || showIndent,
      showLink || showSearchButton,
    ];

    // //default font size values
    // final fontSizes =
    //     fontSizeValues ?? {'Small'.i18n: 'small', 'Large'.i18n: 'large', 'Huge'.i18n: 'huge', 'Clear'.i18n: '0'};
    //
    // //default font family values
    // final fontFamilies = fontFamilyValues ??
    //     {
    //       'Sans Serif': 'sans-serif',
    //       'Serif': 'serif',
    //       'Monospace': 'monospace',
    //       'Ibarra Real Nova': 'ibarra-real-nova',
    //       'SquarePeg': 'square-peg',
    //       'Nunito': 'nunito',
    //       'Pacifico': 'pacifico',
    //       'Roboto Mono': 'roboto-mono',
    //       'Clear'.i18n: 'Clear',
    //     };

    //default button tooltips
    final Map<ToolbarButtons, String> buttonTooltips = tooltips ??
        <ToolbarButtons, String>{
          ToolbarButtons.undo: 'Undo'.i18n,
          ToolbarButtons.redo: 'Redo'.i18n,
          ToolbarButtons.fontFamily: 'Font family'.i18n,
          ToolbarButtons.fontSize: 'Font size'.i18n,
          ToolbarButtons.bold: 'Bold'.i18n,
          ToolbarButtons.subscript: 'Subscript'.i18n,
          ToolbarButtons.superscript: 'Superscript'.i18n,
          ToolbarButtons.italic: 'Italic'.i18n,
          ToolbarButtons.small: 'Small'.i18n,
          ToolbarButtons.underline: 'Underline'.i18n,
          ToolbarButtons.strikeThrough: 'Strike through'.i18n,
          ToolbarButtons.inlineCode: 'Inline code'.i18n,
          ToolbarButtons.color: 'Font color'.i18n,
          ToolbarButtons.backgroundColor: 'Background color'.i18n,
          ToolbarButtons.clearFormat: 'Clear format'.i18n,
          ToolbarButtons.leftAlignment: 'Align left'.i18n,
          ToolbarButtons.centerAlignment: 'Align center'.i18n,
          ToolbarButtons.rightAlignment: 'Align right'.i18n,
          ToolbarButtons.justifyAlignment: 'Justify win width'.i18n,
          ToolbarButtons.direction: 'Text direction'.i18n,
          ToolbarButtons.headerStyle: 'Header style'.i18n,
          ToolbarButtons.listNumbers: 'Numbered list'.i18n,
          ToolbarButtons.listBullets: 'Bullet list'.i18n,
          ToolbarButtons.listChecks: 'Checked list'.i18n,
          ToolbarButtons.codeBlock: 'Code block'.i18n,
          ToolbarButtons.quote: 'Quote'.i18n,
          ToolbarButtons.indentIncrease: 'Increase indent'.i18n,
          ToolbarButtons.indentDecrease: 'Decrease indent'.i18n,
          ToolbarButtons.link: 'Insert URL'.i18n,
          ToolbarButtons.search: 'Search'.i18n,
        };

    return ZdsQuillToolbar(
      key: key,
      axis: axis,
      color: color,
      toolbarSize: toolbarIconSize * 2,
      toolbarSectionSpacing: toolbarSectionSpacing,
      toolbarIconAlignment: toolbarIconAlignment,
      toolbarIconCrossAlignment: toolbarIconCrossAlignment,
      multiRowsDisplay: multiRowsDisplay,
      customButtons: customButtons,
      locale: locale,
      afterButtonPressed: afterButtonPressed,
      children: <Widget>[
        if (showUndo)
          HistoryButton(
            icon: Icons.undo_outlined,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.undo],
            controller: controller,
            undo: true,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showRedo) ...<Widget>[
          HistoryButton(
            icon: Icons.redo_outlined,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.redo],
            controller: controller,
            undo: false,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
          if (showDividers) QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        ],
        if (showHeaderStyle) ...<Widget>[
          SelectHeaderStyleButton(
            tooltip: buttonTooltips[ToolbarButtons.headerStyle],
            controller: controller,
            axis: axis,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
          if (showDividers) QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        ],
        if (showBoldButton)
          ToggleStyleButton(
            attribute: Attribute.bold,
            icon: Icons.format_bold,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.bold],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showSubscript)
          ToggleStyleButton(
            attribute: Attribute.subscript,
            icon: Icons.subscript,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.subscript],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showSuperscript)
          ToggleStyleButton(
            attribute: Attribute.superscript,
            icon: Icons.superscript,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.superscript],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showItalicButton)
          ToggleStyleButton(
            attribute: Attribute.italic,
            icon: Icons.format_italic,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.italic],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showUnderLineButton)
          ToggleStyleButton(
            attribute: Attribute.underline,
            icon: Icons.format_underline,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.underline],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showStrikeThrough)
          ToggleStyleButton(
            attribute: Attribute.strikeThrough,
            icon: Icons.format_strikethrough,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.strikeThrough],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showSmallButton)
          ToggleStyleButton(
            attribute: Attribute.small,
            icon: Icons.format_size,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.small],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showInlineCode)
          ToggleStyleButton(
            attribute: Attribute.inlineCode,
            icon: Icons.code,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.inlineCode],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showDividers) QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showColorButton)
          ColorButton(
            icon: Icons.color_lens,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.color],
            controller: controller,
            background: false,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showBackgroundColorButton)
          ColorButton(
            icon: Icons.format_color_fill,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.backgroundColor],
            controller: controller,
            background: true,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showClearFormat)
          ClearFormatButton(
            icon: Icons.format_clear,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.clearFormat],
            controller: controller,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
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
          QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showAlignmentButtons)
          SelectAlignmentButton(
            controller: controller,
            tooltips: Map<ToolbarButtons, String>.of(buttonTooltips)
              ..removeWhere(
                (ToolbarButtons key, String value) => !<ToolbarButtons>[
                  ToolbarButtons.leftAlignment,
                  ToolbarButtons.centerAlignment,
                  ToolbarButtons.rightAlignment,
                  ToolbarButtons.justifyAlignment,
                ].contains(key),
              ),
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            showLeftAlignment: showLeftAlignment,
            showCenterAlignment: showCenterAlignment,
            showRightAlignment: showRightAlignment,
            showJustifyAlignment: showJustifyAlignment,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showDirection)
          ToggleStyleButton(
            attribute: Attribute.rtl,
            tooltip: buttonTooltips[ToolbarButtons.direction],
            controller: controller,
            icon: Icons.format_textdirection_r_to_l,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showDividers &&
            isButtonGroupShown[1] &&
            (isButtonGroupShown[2] || isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
          QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showDividers &&
            showHeaderStyle &&
            isButtonGroupShown[2] &&
            (isButtonGroupShown[3] || isButtonGroupShown[4] || isButtonGroupShown[5]))
          QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showListNumbers)
          ToggleStyleButton(
            attribute: Attribute.ol,
            tooltip: buttonTooltips[ToolbarButtons.listNumbers],
            controller: controller,
            icon: Icons.format_list_numbered,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showListBullets)
          ToggleStyleButton(
            attribute: Attribute.ul,
            tooltip: buttonTooltips[ToolbarButtons.listBullets],
            controller: controller,
            icon: Icons.format_list_bulleted,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showListCheck)
          ToggleCheckListButton(
            attribute: Attribute.unchecked,
            tooltip: buttonTooltips[ToolbarButtons.listChecks],
            controller: controller,
            icon: Icons.check_box,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showCodeBlock)
          ToggleStyleButton(
            attribute: Attribute.codeBlock,
            tooltip: buttonTooltips[ToolbarButtons.codeBlock],
            controller: controller,
            icon: Icons.code_off,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showDividers && isButtonGroupShown[3] && (isButtonGroupShown[4] || isButtonGroupShown[5]))
          QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showQuote)
          ToggleStyleButton(
            attribute: Attribute.blockQuote,
            tooltip: buttonTooltips[ToolbarButtons.quote],
            controller: controller,
            icon: Icons.format_quote,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showIndent)
          IndentButton(
            icon: Icons.format_indent_increase,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.indentIncrease],
            controller: controller,
            isIncrease: true,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showIndent)
          IndentButton(
            icon: Icons.format_indent_decrease,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.indentDecrease],
            controller: controller,
            isIncrease: false,
            iconTheme: iconTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        if (showDividers && isButtonGroupShown[4] && isButtonGroupShown[5])
          QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        if (showLink)
          LinkStyleButton(
            tooltip: buttonTooltips[ToolbarButtons.link],
            controller: controller,
            iconSize: toolbarIconSize,
            iconTheme: iconTheme,
            dialogTheme: dialogTheme,
            afterButtonPressed: afterButtonPressed,
            linkRegExp: linkRegExp,
            linkDialogAction: linkDialogAction,
          ),
        if (showSearchButton)
          SearchButton(
            icon: Icons.search,
            iconSize: toolbarIconSize,
            tooltip: buttonTooltips[ToolbarButtons.search],
            controller: controller,
            iconTheme: iconTheme,
            dialogTheme: dialogTheme,
            afterButtonPressed: afterButtonPressed,
          ),
        // if (showFontFamily)
        //   QuillFontFamilyButton(
        //     iconTheme: iconTheme,
        //     iconSize: toolbarIconSize,
        //     tooltip: buttonTooltips[ToolbarButtons.fontFamily],
        //     attribute: Attribute.font,
        //     controller: controller,
        //     rawItemsMap: fontFamilies,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        // if (showFontSize)
        //   QuillFontSizeButton(
        //     iconTheme: iconTheme,
        //     iconSize: toolbarIconSize,
        //     tooltip: buttonTooltips[ToolbarButtons.fontSize],
        //     attribute: Attribute.size,
        //     controller: controller,
        //     rawItemsMap: fontSizes,
        //     afterButtonPressed: afterButtonPressed,
        //   ),
        if (customButtons.isNotEmpty)
          if (showDividers) QuillDivider(axis, color: sectionDividerColor, space: sectionDividerSpace),
        for (final QuillCustomButton customButton in customButtons)
          if (customButton.child != null) ...<Widget>[
            InkWell(
              onTap: customButton.onTap,
              child: customButton.child,
            ),
          ] else ...<Widget>[
            CustomButton(
              onPressed: customButton.onTap,
              icon: customButton.icon,
              iconColor: customButton.iconColor,
              iconSize: toolbarIconSize,
              iconTheme: iconTheme,
              afterButtonPressed: afterButtonPressed,
              tooltip: customButton.tooltip,
            ),
          ],
      ],
    );
  }
}
