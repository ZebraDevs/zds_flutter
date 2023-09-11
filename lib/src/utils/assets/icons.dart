// ignore_for_file: constant_identifier_names, public_member_api_docs

// To add new icons, follow the instructions in https://confluence.zebra.com/display/IDD/Internal+developer+resources
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:zeta_flutter/zeta_flutter.dart';

/// Identifiers for the supported icons.
///
/// Use with the [Icon] class to show specific icons.
///
/// Icons are identified by their name as listed below, e.g. [ZdsIcons.add_task].
///
/// ```dart
///  Icon(
///    ZdsIcons.add_task,
///    color: Colors.green,
///    size: 24.0,
///    semanticLabel: 'Text to announce in accessibility modes',
///  )
/// ```
///
/// See also:
///
///  * [Icon].
class ZdsIcons {
  ZdsIcons._();

  static const String _fontFamily = 'zds-icons';
  static const String _fontPackage = 'zds_flutter';

  static const IconData action = IconData(0xe9ad, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData add = IconData(0xe903, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData add_link = IconData(0xe902, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData add_task = IconData(0xe94c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData add_user = IconData(0xe904, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData attachment = IconData(0xe905, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData audio = IconData(0xe9af, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData audio_file = IconData(0xe906, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData audit_activity = IconData(0xe900, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData back = IconData(0xe907, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData break_ = IconData(0xe9b0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData broadcast = IconData(0xe9b1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData building = IconData(0xe9b2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar = IconData(0xe96f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_3_day = IconData(0xe9b3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_available = IconData(0xe9b4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_day = IconData(0xe9b5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_edit = IconData(0xe9b6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_month = IconData(0xe9b7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_rollover = IconData(0xe9b8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_today = IconData(0xe965, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_trade = IconData(0xe9ba, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_unavailable = IconData(0xe96c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_week = IconData(0xe9bc, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData calendar_year = IconData(0xe9bd, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData call = IconData(0xe9bf, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData camera = IconData(0xe95d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData camera_switch = IconData(0xe95c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData category = IconData(0xe908, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData certified = IconData(0xe9c0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData channel = IconData(0xe909, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat = IconData(0xe9c7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat_bot = IconData(0xe9c1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat_message = IconData(0xe9c5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat_message_read = IconData(0xe9c2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat_search = IconData(0xe9c6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chat_unread_active = IconData(0xe90a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData check = IconData(0xe90b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData check_circle = IconData(0xe90c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chevron_down = IconData(0xe90d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chevron_left = IconData(0xe90e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chevron_right = IconData(0xe90f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData chevron_up = IconData(0xe910, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clear = IconData(0xe963, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clipboard = IconData(0xe945, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock = IconData(0xe9d8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_available = IconData(0xe9c8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_bid = IconData(0xe9ca, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_edit = IconData(0xe9cc, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_filled = IconData(0xe98b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_flexible = IconData(0xe9cd, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_in_progress = IconData(0xe9ce, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_info = IconData(0xe9cf, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_missed = IconData(0xe9d0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_on = IconData(0xe9d1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_rollover = IconData(0xe9d2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_segment = IconData(0xe9d3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_start = IconData(0xe9d4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_stop = IconData(0xe9d5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_switch = IconData(0xe9d6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData clock_timer = IconData(0xe9d7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData close = IconData(0xe911, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData close_circle = IconData(0xe944, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData cloud_download = IconData(0xe9d9, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData cloud_off = IconData(0xe964, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData cloud_upload = IconData(0xe9da, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData complaint = IconData(0xe912, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData copy = IconData(0xe966, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData dashboard = IconData(0xe967, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData delete = IconData(0xe913, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData details = IconData(0xe914, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData dialpad = IconData(0xe9db, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData download = IconData(0xe9dc, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData edit = IconData(0xe916, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData edit_notifications = IconData(0xe94d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData edit_redo = IconData(0xe968, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData edit_undo = IconData(0xe969, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData email = IconData(0xe9e0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData email_forward = IconData(0xe9dd, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData email_reply = IconData(0xe9df, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData email_reply_all = IconData(0xe9de, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData empty = IconData(0xe99a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData ess = IconData(0xe94f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData expand = IconData(0xe915, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData eye_preview = IconData(0xe96a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData eye_view = IconData(0xe96b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file = IconData(0xf016, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_archive = IconData(0xf1c6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_audio = IconData(0xf1c7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_code = IconData(0xf1c9, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_excel = IconData(0xf1c3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_image = IconData(0xf1c5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_pdf = IconData(0xf1c1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_powerpoint = IconData(0xf1c4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_text = IconData(0xf0f6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_video = IconData(0xf1c8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData file_word = IconData(0xf1c2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData filter = IconData(0xe917, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData flag = IconData(0xe96d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData flip = IconData(0xe96e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData folder = IconData(0xe9e1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData form = IconData(0xe918, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData format_bold = IconData(0xe923, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData format_italic = IconData(0xe924, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData forward = IconData(0xe970, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData fullscreen = IconData(0xe972, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData fullscreen_exit = IconData(0xe971, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData funnel = IconData(0xe919, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData globe = IconData(0xe9e2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData glossary = IconData(0xe901, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData grid = IconData(0xe973, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData headset = IconData(0xe9e3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData history = IconData(0xe91a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData home = IconData(0xe975, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData horn = IconData(0xe91b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData hourglass = IconData(0xe9e4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData how_do_I = IconData(0xe91c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData image = IconData(0xe976, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData import = IconData(0xe9e5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData inbox = IconData(0xe9e6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData indicator_alert = IconData(0xe977, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData indicator_cancel = IconData(0xe978, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData indicator_check = IconData(0xe979, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData indicator_help = IconData(0xe97a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData indicator_info = IconData(0xe97b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData info = IconData(0xe921, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData keyboard = IconData(0xe9e7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData launch = IconData(0xe922, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData lightbulb = IconData(0xe9e8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData link = IconData(0xe97d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData link_add = IconData(0xe97c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_bullet = IconData(0xe97f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_bullet_contained = IconData(0xe97e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_bulleted = IconData(0xe91f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_details = IconData(0xe980, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_feedback = IconData(0xe981, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_form = IconData(0xe982, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_numbered = IconData(0xe920, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData list_task = IconData(0xe983, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData location = IconData(0xe9ea, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData location_off = IconData(0xe9e9, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData lock = IconData(0xe985, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData lock_undo = IconData(0xe984, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData maintenance = IconData(0xe9eb, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData meal = IconData(0xe9ec, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData menu = IconData(0xe927, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData message_read = IconData(0xe928, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData mic = IconData(0xe9ed, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData minus = IconData(0xe987, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData mode_dark = IconData(0xe988, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData mode_light = IconData(0xe989, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData money = IconData(0xe929, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData more_hori = IconData(0xe98a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData more_vert = IconData(0xe92a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData mywork = IconData(0xe950, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData navigate = IconData(0xe9ee, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData negative = IconData(0xe92b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData new_message = IconData(0xe92c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData note = IconData(0xe98c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData notification = IconData(0xe92d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData notification_silence = IconData(0xe95f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData notifications_off = IconData(0xe948, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData notifications_off_outlined =
      IconData(0xe92f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData open_in_small = IconData(0xe95e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData open_new = IconData(0xe9f1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData open_new_off = IconData(0xe9f0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData open_shift = IconData(0xe962, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData org = IconData(0xe99d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData palette = IconData(0xe9f2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData paper = IconData(0xe98d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData partially_approved = IconData(0xe95a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData partner = IconData(0xe9f3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData pdf = IconData(0xe92e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_assign = IconData(0xe9f4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_clock = IconData(0xe9f5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_info = IconData(0xe9f6, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_manager = IconData(0xe9f7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_move = IconData(0xe9f8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_swap = IconData(0xe9f9, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData person_walk = IconData(0xe9fa, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData phone = IconData(0xe9fb, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData pin = IconData(0xe931, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData pinboard = IconData(0xe951, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData plus = IconData(0xe98f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData point_gift = IconData(0xe9fc, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData point_heart = IconData(0xe9fd, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData point_money = IconData(0xe9fe, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData point_star = IconData(0xe9ff, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData point_token = IconData(0xea00, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData positive = IconData(0xe932, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData preview = IconData(0xe933, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData print = IconData(0xe990, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData profile = IconData(0xea01, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData project = IconData(0xe934, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData publish = IconData(0xea02, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qchat = IconData(0xe952, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qcheck = IconData(0xe954, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qdocs = IconData(0xe955, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qforms = IconData(0xe956, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qnote = IconData(0xe94b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qnote_expired = IconData(0xe94e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qnotes = IconData(0xe957, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qr = IconData(0xea03, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qrcode = IconData(0xe94a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qstar = IconData(0xe958, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData queue = IconData(0xe991, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData qvisual = IconData(0xe959, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData radio_off = IconData(0xe992, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData radio_on = IconData(0xe993, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData rar = IconData(0xe953, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData react_add = IconData(0xea04, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData react_angry = IconData(0xea05, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData react_thumbsdown = IconData(0xea06, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData react_thumbsup = IconData(0xea07, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData reassign = IconData(0xe947, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData recall = IconData(0xe994, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData redo_variant = IconData(0xe925, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData refresh = IconData(0xe995, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData reorder = IconData(0xe996, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData repeat = IconData(0xe997, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData report = IconData(0xe935, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData reset = IconData(0xe998, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData review = IconData(0xe936, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sales = IconData(0xe937, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData save = IconData(0xea08, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData schedule = IconData(0xe938, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData scheduling = IconData(0xe99e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData search = IconData(0xe939, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData search_advance = IconData(0xe949, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData security = IconData(0xe9a4, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData send = IconData(0xe93a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData settings_gear = IconData(0xe99b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData settings_tune = IconData(0xe99c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData share = IconData(0xea0b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData share_file = IconData(0xea0a, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sign_out = IconData(0xe93b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sm = IconData(0xe95b, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sort = IconData(0xe93c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sphere = IconData(0xe9c9, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData star = IconData(0xe93d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData start_outlined = IconData(0xe946, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData store = IconData(0xea0d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData store_swap = IconData(0xea0c, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData strikethrough = IconData(0xe91e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData subscription = IconData(0xe9a5, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData summary = IconData(0xe93e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData support = IconData(0xe93f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData surveys = IconData(0xe99f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData switch_ = IconData(0xe9a0, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData sync = IconData(0xe9a1, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData synchronize = IconData(0xe940, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData tag = IconData(0xe941, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData task = IconData(0xe942, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData taskmanager = IconData(0xe9a2, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData tiers = IconData(0xe98e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData timecard = IconData(0xe999, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData timecard_approve = IconData(0xea0e, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData timecard_warning = IconData(0xea0f, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData translation = IconData(0xe9a3, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData trash = IconData(0xe9a8, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData unclaim = IconData(0xe943, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData underlined = IconData(0xe91d, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData undo_variant = IconData(0xe926, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData unsubscribe = IconData(0xe9a7, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData update = IconData(0xe9aa, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData upload = IconData(0xea11, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData user = IconData(0xea15, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData user_add = IconData(0xea12, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData user_group = IconData(0xea13, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData user_multiple = IconData(0xea14, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData vacation = IconData(0xea16, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData verified = IconData(0xea17, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData video = IconData(0xe974, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData walk = IconData(0xe986, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData wifi = IconData(0xea18, fontFamily: _fontFamily, fontPackage: _fontPackage);
  static const IconData write = IconData(0xe9ac, fontFamily: _fontFamily, fontPackage: _fontPackage);

  static const _extensions = {
    '.au': ZdsIcons.file_audio,
    '.avi': ZdsIcons.file_video,
    '.csv': ZdsIcons.file_text,
    '.doc': ZdsIcons.file_word,
    '.docx': ZdsIcons.file_word,
    '.flv': ZdsIcons.file_video,
    '.gif': ZdsIcons.file_image,
    '.htm': ZdsIcons.file,
    '.ico': ZdsIcons.file_image,
    '.jpg': ZdsIcons.file_image,
    '.jpeg': ZdsIcons.file_image,
    '.m4v': ZdsIcons.file_video,
    '.midi': ZdsIcons.file_audio,
    '.mov': ZdsIcons.file_video,
    '.mp3': ZdsIcons.file_audio,
    '.mp4': ZdsIcons.file_video,
    '.mpg': ZdsIcons.file_video,
    '.mpeg': ZdsIcons.file_video,
    '.pdf': ZdsIcons.file_pdf,
    '.png': ZdsIcons.file_image,
    '.bmp': ZdsIcons.file_image,
    '.ppt': ZdsIcons.file_powerpoint,
    '.pptx': ZdsIcons.file_powerpoint,
    '.qt': ZdsIcons.file,
    '.rar': ZdsIcons.file_archive,
    '.rtf': ZdsIcons.file_text,
    '.tif': ZdsIcons.file_image,
    '.tiff': ZdsIcons.file_image,
    '.ttf': ZdsIcons.file,
    '.txt': ZdsIcons.file_text,
    '.wav': ZdsIcons.file_audio,
    '.xls': ZdsIcons.file_excel,
    '.xlsx': ZdsIcons.file_excel,
    '.xml': ZdsIcons.file_excel,
    '.zip': ZdsIcons.file_archive,
    '.url': ZdsIcons.file,
  };

  // Text Documents: #376FC9
// PDF & PPT (distinguished as they are commonly used): #DB0D00
// Images: #F56200
// Video: #6F00C6
// Audio: #70A300
// Spreadsheets: #1F802E
// Misc: #888888
  static Color iconColor(String ext) {
    switch (ext) {
      case '.doc':
      case '.docx':
      case '.rtf':
      case '.ttf':
      case '.txt':
        return ZetaColorBase.blue.shade60;

      case '.pdf':
      case '.ppt':
      case '.pptx':
        return ZetaColorBase.red.shade80;

      case '.gif':
      case '.ico':
      case '.jpg':
      case '.jpeg':
      case '.png':
      case '.tif':
      case '.tiff':
        return ZetaColorBase.orange.shade50;

      case '.flv':
      case '.m4v':
      case '.mov':
      case '.mpeg':
      case '.mpg':
      case '.qt':
        return ZetaColorBase.purple.shade70;

      case '.au':
      case '.avi':
      case '.midi':
      case '.mp3':
      case '.mp4':
      case '.wav':
        return ZetaColorBase.green.shade40;

      case '.csv':
      case '.xml':
      case '.xls':
      case '.xlsx':
        return ZetaColorBase.green.shade80;

      case '.htm':
      case '.rar':
      case '.url':
      case '.zip':
      default:
        return ZetaColorBase.greyWarm.shade50;
    }
  }

  static IconData _resolveFileIcon(String? name) {
    if (name == null) return ZdsIcons.file;
    final ext = path.extension(name);
    return _extensions[ext] ?? ZdsIcons.file;
  }

  static Color? _resolveFileColor(String? name) {
    if (name == null) return null;
    final ext = path.extension(name).toLowerCase();
    return iconColor(ext);
  }
}

extension IconDataFromExt on String {
  /// Assuming the string is a file name, this function returns the corresponding icon for the filetype.
  ///
  /// Here the icon for an image will be returned
  ///
  /// ```dart
  ///  Icon(
  ///    'example.jpg'.fileIcon(),
  ///    color: green,
  ///    size: 24.0,
  ///    semanticLabel: 'Text to announce in accessibility modes',
  ///  )
  /// ```
  ///
  /// If the string does not contain a file type, or contains an unrecognized filetype, [ZdsIcons.file] will be returned.
  IconData fileIcon() {
    return ZdsIcons._resolveFileIcon(this);
  }

  Icon coloredFileIcon() {
    return Icon(ZdsIcons._resolveFileIcon(this), color: ZdsIcons._resolveFileColor(this));
  }
}
