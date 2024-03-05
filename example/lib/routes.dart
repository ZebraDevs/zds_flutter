import 'package:flutter/material.dart';
import 'pages/components/audio_recorder.dart';

import 'home.dart';
import 'pages/assets/animations.dart';
import 'pages/assets/icons.dart';
import 'pages/assets/images.dart';
import 'pages/components/app_bar.dart';
import 'pages/components/audio_player.dart';
import 'pages/components/big_toggle_button.dart';
import 'pages/components/block_table.dart';
import 'pages/components/bottom_bar.dart';
import 'pages/components/bottom_sheet.dart';
import 'pages/components/bottom_tab_bar.dart';
import 'pages/components/bottom_tab_scaffold.dart';
import 'pages/components/button.dart';
import 'pages/components/calendar.dart';
import 'pages/components/camera_example.dart';
import 'pages/components/card_actions.dart';
import 'pages/components/card.dart';
import 'pages/components/chat.dart';
import 'pages/components/conditional_wrapper.dart';
import 'pages/components/date_picker.dart';
import 'pages/components/day_picker_demo.dart';
import 'pages/components/default_flutter.dart';
import 'pages/components/empty_list_view.dart';
import 'pages/components/empty_view.dart';
import 'pages/components/expandable.dart';
import 'pages/components/expansion_tile.dart';
import 'pages/components/file_picker.dart';
import 'pages/components/html_view.dart';
import 'pages/components/icon_text_button.dart';
import 'pages/components/image_picker.dart';
import 'pages/components/index.dart';
import 'pages/components/infinite_list.dart';
import 'pages/components/information_bar.dart';
import 'pages/components/interactive_viewer.dart';
import 'pages/components/list_tile_wrapper.dart';
import 'pages/components/list_tile.dart';
import 'pages/components/list.dart';
import 'pages/components/modal.dart';
import 'pages/components/navigation_menu.dart';
import 'pages/components/popover.dart';
import 'pages/components/profile.dart';
import 'pages/components/properties_list.dart';
import 'pages/components/quill_editor_demo.dart';
import 'pages/components/radio_list.dart';
import 'pages/components/search.dart';
import 'pages/components/sheet_header.dart';
import 'pages/components/slidable_list_tile.dart';
import 'pages/components/speed_scrollable_list.dart';
import 'pages/components/speed_slider.dart';
import 'pages/components/split_navigator.dart';
import 'pages/components/star_rating.dart';
import 'pages/components/stats_card.dart';
import 'pages/components/tab_bar.dart';
import 'pages/components/tag_list.dart';
import 'pages/components/tag.dart';
import 'pages/components/text_field.dart';
import 'pages/components/toast.dart';
import 'pages/components/toolbar.dart';
import 'pages/components/vertical_nav.dart';
import 'pages/theme/colors.dart';
import 'pages/theme/text.dart';
import 'pages/utils/color_utils.dart';

final kRoutes = {
  'Components': [
    const DemoRoute(title: 'App bar', wrapper: false, child: AppBarDemo()),
    const DemoRoute(title: 'Audio Player', child: AudioPlayerDemo()),
    const DemoRoute(title: 'Audio Recorder', child: AudioRecorderDemo()),
    const DemoRoute(title: 'Big Toggle Button', child: BigToggleButtonDemo()),
    const DemoRoute(title: 'Block Table', child: BlockTableDemo()),
    const DemoRoute(title: 'Bottom bar', child: BottomBarDemo()),
    const DemoRoute(title: 'Bottom Sheet', child: BottomSheetDemo()),
    const DemoRoute(title: 'Bottom Tab Bar Scaffold', child: BottomTabScaffoldDemo()),
    const DemoRoute(title: 'Bottom tab bar', child: BottomTabBarDemo()),
    const DemoRoute(title: 'Buttons', child: ButtonDemo()),
    const DemoRoute(title: 'Calendar', child: CalendarDemo()),
    const DemoRoute(title: 'Camera', wrapper: false, child: CameraExample()),
    const DemoRoute(title: 'Card Actions', child: CardActionsDemo()),
    const DemoRoute(title: 'Cards', child: CardDemo()),
    const DemoRoute(title: 'Chat', child: ChatDemo()),
    const DemoRoute(title: 'Conditional Wrapper', wrapper: false, child: ConditionalWrapperExample()),
    const DemoRoute(title: 'Date pickers', child: DatePickerDemo()),
    const DemoRoute(title: 'Days picker', child: DayPickerDemo()),
    const DemoRoute(title: 'Default Flutter', child: DefaultFlutter()),
    const DemoRoute(title: 'Empty list view', child: EmptyListView()),
    const DemoRoute(title: 'Empty', child: EmptyViewDemo()),
    const DemoRoute(title: 'Expandable', child: ExpandableDemo()),
    const DemoRoute(title: 'Expansion Tile', child: ExpansionTileDemo()),
    const DemoRoute(title: 'File Picker', child: FilePickerDemo()),
    const DemoRoute(title: 'Html Preview', wrapper: false, child: HtmlPreview()),
    const DemoRoute(title: 'IconTextButton', child: IconTextButtonDemo()),
    const DemoRoute(title: 'ImagePicker', child: ImagePickerDemo()),
    const DemoRoute(title: 'Index component', child: IndexDemo()),
    const DemoRoute(title: 'Infinite list', child: InfiniteListDemo()),
    const DemoRoute(title: 'Information bar', child: InformationBarDemo()),
    const DemoRoute(title: 'Interactive Viewer', wrapper: false, child: InteractiveViewerExample()),
    const DemoRoute(title: 'List tile wrapper', child: ListTileWrapperDemo()),
    const DemoRoute(title: 'List tiles', child: ListTileDemo()),
    const DemoRoute(title: 'Lists', child: ListDemo()),
    const DemoRoute(title: 'Modal', child: ModalDemo()),
    const DemoRoute(title: 'Navigation menu', child: NavigationMenuDemo()),
    const DemoRoute(title: 'PopOver', wrapper: false, child: PopOverDemo()),
    const DemoRoute(title: 'Profile', wrapper: false, child: ProfileDemo()),
    const DemoRoute(title: 'Properties List', child: PropertiesListDemo()),
    const DemoRoute(title: 'Quill Editor', wrapper: false, child: QuillEditorDemo()),
    const DemoRoute(title: 'Radio List', child: RadioListDemo()),
    const DemoRoute(title: 'Search', wrapper: false, child: SearchDemo()),
    const DemoRoute(title: 'Sheet Headers', child: SheetHeaderDemo()),
    const DemoRoute(title: 'Slidable list tiles', child: SlidableListTileDemo()),
    const DemoRoute(title: 'Speed Scrollable List', child: SpeedScrollableListDemo()),
    const DemoRoute(title: 'Speed Slider', child: SpeedSliderDemo()),
    const DemoRoute(title: 'Split Navigation', wrapper: false, child: SplitNavigatorDemo()),
    const DemoRoute(title: 'Star Rating', child: StarRatingExample()),
    const DemoRoute(title: 'Stats card', child: StatsCardDemo()),
    const DemoRoute(title: 'Tab bar', wrapper: false, child: TabBarDemo()),
    const DemoRoute(title: 'Tag list', child: TagListDemo()),
    const DemoRoute(title: 'Tags', child: TagDemo()),
    const DemoRoute(title: 'Text Field', child: TextFieldDemo()),
    const DemoRoute(title: 'Toast', wrapper: false, child: ToastDemo()),
    const DemoRoute(title: 'Toolbar', wrapper: false, child: ToolBarDemo()),
    const DemoRoute(title: 'Vertical Navigation', child: VerticalNavDemo()),
  ],
  'Assets': [
    const DemoRoute(title: 'Animations', child: AnimationsDemo()),
    const DemoRoute(title: 'Images', child: ImagesDemo()),
    const DemoRoute(title: 'Icons', child: IconsDemo())
  ],
  'Theme': [
    const DemoRoute(title: 'Colors', child: ColorsDemo()),
    const DemoRoute(title: 'Colors generator', child: ColorUtilsDemo()),
    const DemoRoute(title: 'Typography', child: TextDemo()),
  ],
};

final kFlattRoutes = kRoutes.keys.expand<DemoRoute>((key) => kRoutes[key]!).toList();

final kHomeRoute = DemoRoute(
  title: 'ZDS Flutter Demo',
  routeName: Navigator.defaultRouteName,
  wrapper: false,
  child: Builder(builder: (context) {
    return HomePage();
  }),
);

final kAllRoutes = {
  Navigator.defaultRouteName: (context) => kHomeRoute,
  for (DemoRoute route in kFlattRoutes) route.routeName: (context) => route,
};

class DemoRoute extends StatelessWidget {
  final bool wrapper;
  final String title;
  final Widget child;
  final String? _routeName;

  String get routeName => _routeName ?? '/${child.runtimeType}';

  const DemoRoute({Key? key, String? routeName, this.wrapper = true, required this.title, required this.child})
      : _routeName = routeName,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!wrapper) {
      return child;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: child,
    );
  }
}
