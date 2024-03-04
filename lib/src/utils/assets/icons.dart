// ignore_for_file: constant_identifier_names, public_member_api_docs

// To add new icons, follow the instructions in https://confluence.zebra.com/display/IDD/Internal+developer+resources

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

import '../../../zds_flutter.dart';

/// Identifiers for the supported Zebra icons.
///
/// Use with the [Icon] class to show specific icons.
///
/// Icons are identified by their name as listed below, e.g. [ZdsIcons.add_task].
///
/// ```dart
///  Icon(
///    ZdsIcons.add_task,
///    color: ZdsColors.green,
///    size: 24.0,
///    semanticLabel: 'Text to announce in accessibility modes',
///  )
/// ```
///
/// See also:
///  * [Icon]

class ZdsIcons {
  ZdsIcons._();

  static const String _family = 'zds-icons';

  static const IconData action = IconData(0xe9ad, fontFamily: _family, fontPackage: packageName);
  static const IconData add = IconData(0xe903, fontFamily: _family, fontPackage: packageName);
  static const IconData add_link = IconData(0xe902, fontFamily: _family, fontPackage: packageName);
  static const IconData add_task = IconData(0xe94c, fontFamily: _family, fontPackage: packageName);
  static const IconData add_user = IconData(0xe904, fontFamily: _family, fontPackage: packageName);
  static const IconData attachment = IconData(0xe905, fontFamily: _family, fontPackage: packageName);
  static const IconData audio = IconData(0xe9af, fontFamily: _family, fontPackage: packageName);
  static const IconData audio_file = IconData(0xe906, fontFamily: _family, fontPackage: packageName);
  static const IconData audit_activity = IconData(0xe900, fontFamily: _family, fontPackage: packageName);
  static const IconData back = IconData(0xe907, fontFamily: _family, fontPackage: packageName);
  static const IconData book_open = IconData(0xe9a9, fontFamily: _family, fontPackage: packageName);
  static const IconData break_filled = IconData(0xe9b0, fontFamily: _family, fontPackage: packageName);
  static const IconData broadcast = IconData(0xe9b1, fontFamily: _family, fontPackage: packageName);
  static const IconData building = IconData(0xe9b2, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar = IconData(0xe96f, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_3_day = IconData(0xe9b3, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_available = IconData(0xe9b4, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_day = IconData(0xe9b5, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_edit = IconData(0xe9b6, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_month = IconData(0xe9b7, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_next = IconData(0xe9ab, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_rollover = IconData(0xe9b8, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_today = IconData(0xe965, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_trade = IconData(0xe9ba, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_unavailable = IconData(0xe96c, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_week = IconData(0xe9bc, fontFamily: _family, fontPackage: packageName);
  static const IconData calendar_year = IconData(0xe9bd, fontFamily: _family, fontPackage: packageName);
  static const IconData call = IconData(0xe9bf, fontFamily: _family, fontPackage: packageName);
  static const IconData camera = IconData(0xe95d, fontFamily: _family, fontPackage: packageName);
  static const IconData camera_switch = IconData(0xe95c, fontFamily: _family, fontPackage: packageName);
  static const IconData category = IconData(0xe908, fontFamily: _family, fontPackage: packageName);
  static const IconData certified = IconData(0xe9c0, fontFamily: _family, fontPackage: packageName);
  static const IconData channel = IconData(0xe909, fontFamily: _family, fontPackage: packageName);
  static const IconData chat = IconData(0xe9c7, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_bot = IconData(0xe9c1, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_message = IconData(0xe9c5, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_message_read = IconData(0xe9c2, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_message_unread = IconData(0xe960, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_search = IconData(0xe9c6, fontFamily: _family, fontPackage: packageName);
  static const IconData chat_unread_active = IconData(0xe90a, fontFamily: _family, fontPackage: packageName);
  static const IconData check = IconData(0xe90b, fontFamily: _family, fontPackage: packageName);
  static const IconData check_circle = IconData(0xe90c, fontFamily: _family, fontPackage: packageName);
  static const IconData chevron_down = IconData(0xe90d, fontFamily: _family, fontPackage: packageName);
  static const IconData chevron_left = IconData(0xe90e, fontFamily: _family, fontPackage: packageName);
  static const IconData chevron_right = IconData(0xe90f, fontFamily: _family, fontPackage: packageName);
  static const IconData chevron_up = IconData(0xe910, fontFamily: _family, fontPackage: packageName);
  static const IconData clear = IconData(0xe963, fontFamily: _family, fontPackage: packageName);
  static const IconData clipboard = IconData(0xe945, fontFamily: _family, fontPackage: packageName);
  static const IconData clock = IconData(0xe9d8, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_available = IconData(0xe9c8, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_bid = IconData(0xe9ca, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_edit = IconData(0xe9cc, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_filled = IconData(0xe98b, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_flexible = IconData(0xe9cd, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_in_progress = IconData(0xe9ce, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_info = IconData(0xe9cf, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_missed = IconData(0xe9d0, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_on = IconData(0xe9d1, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_rollover = IconData(0xe9d2, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_segment = IconData(0xe9d3, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_start = IconData(0xe9d4, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_stop = IconData(0xe9d5, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_switch = IconData(0xe9d6, fontFamily: _family, fontPackage: packageName);
  static const IconData clock_timer = IconData(0xe9d7, fontFamily: _family, fontPackage: packageName);
  static const IconData close = IconData(0xe911, fontFamily: _family, fontPackage: packageName);
  static const IconData close_circle = IconData(0xe944, fontFamily: _family, fontPackage: packageName);
  static const IconData cloud_download = IconData(0xe9d9, fontFamily: _family, fontPackage: packageName);
  static const IconData cloud_off = IconData(0xe964, fontFamily: _family, fontPackage: packageName);
  static const IconData cloud_upload = IconData(0xe9da, fontFamily: _family, fontPackage: packageName);
  static const IconData complaint = IconData(0xe912, fontFamily: _family, fontPackage: packageName);
  static const IconData copy = IconData(0xe966, fontFamily: _family, fontPackage: packageName);
  static const IconData dashboard = IconData(0xe967, fontFamily: _family, fontPackage: packageName);
  static const IconData decrease = IconData(0xe961, fontFamily: _family, fontPackage: packageName);
  static const IconData delete = IconData(0xe913, fontFamily: _family, fontPackage: packageName);
  static const IconData details = IconData(0xe914, fontFamily: _family, fontPackage: packageName);
  static const IconData dialpad = IconData(0xe9db, fontFamily: _family, fontPackage: packageName);
  static const IconData download = IconData(0xe9dc, fontFamily: _family, fontPackage: packageName);
  static const IconData edit = IconData(0xe916, fontFamily: _family, fontPackage: packageName);
  static const IconData edit_notifications = IconData(0xe94d, fontFamily: _family, fontPackage: packageName);
  static const IconData edit_redo = IconData(0xe968, fontFamily: _family, fontPackage: packageName);
  static const IconData edit_undo = IconData(0xe969, fontFamily: _family, fontPackage: packageName);
  static const IconData email = IconData(0xe9e0, fontFamily: _family, fontPackage: packageName);
  static const IconData email_forward = IconData(0xe9dd, fontFamily: _family, fontPackage: packageName);
  static const IconData email_reply = IconData(0xe9df, fontFamily: _family, fontPackage: packageName);
  static const IconData email_reply_all = IconData(0xe9de, fontFamily: _family, fontPackage: packageName);
  static const IconData empty = IconData(0xe99a, fontFamily: _family, fontPackage: packageName);
  static const IconData ess = IconData(0xe94f, fontFamily: _family, fontPackage: packageName);
  static const IconData expand = IconData(0xe915, fontFamily: _family, fontPackage: packageName);
  static const IconData eye_preview = IconData(0xe96a, fontFamily: _family, fontPackage: packageName);
  static const IconData eye_view = IconData(0xe96b, fontFamily: _family, fontPackage: packageName);
  static const IconData file_archive_o = IconData(0xf1c6, fontFamily: _family, fontPackage: packageName);
  static const IconData file_audio_o = IconData(0xf1c7, fontFamily: _family, fontPackage: packageName);
  static const IconData file_code_o = IconData(0xf1c9, fontFamily: _family, fontPackage: packageName);
  static const IconData file_excel_o = IconData(0xf1c3, fontFamily: _family, fontPackage: packageName);
  static const IconData file_image_o = IconData(0xf1c5, fontFamily: _family, fontPackage: packageName);
  static const IconData file_o = IconData(0xf016, fontFamily: _family, fontPackage: packageName);
  static const IconData file_pdf_o = IconData(0xf1c1, fontFamily: _family, fontPackage: packageName);
  static const IconData file_powerpoint_o = IconData(0xf1c4, fontFamily: _family, fontPackage: packageName);
  static const IconData file_text_o = IconData(0xf0f6, fontFamily: _family, fontPackage: packageName);
  static const IconData file_video_o = IconData(0xf1c8, fontFamily: _family, fontPackage: packageName);
  static const IconData file_word_o = IconData(0xf1c2, fontFamily: _family, fontPackage: packageName);
  static const IconData filter = IconData(0xe917, fontFamily: _family, fontPackage: packageName);
  static const IconData flag = IconData(0xe96d, fontFamily: _family, fontPackage: packageName);
  static const IconData flip = IconData(0xe96e, fontFamily: _family, fontPackage: packageName);
  static const IconData folder = IconData(0xe9e1, fontFamily: _family, fontPackage: packageName);
  static const IconData form = IconData(0xe918, fontFamily: _family, fontPackage: packageName);
  static const IconData forward = IconData(0xe970, fontFamily: _family, fontPackage: packageName);
  static const IconData fullscreen = IconData(0xe972, fontFamily: _family, fontPackage: packageName);
  static const IconData fullscreen_exit = IconData(0xe971, fontFamily: _family, fontPackage: packageName);
  static const IconData funnel = IconData(0xe919, fontFamily: _family, fontPackage: packageName);
  static const IconData globe = IconData(0xe9e2, fontFamily: _family, fontPackage: packageName);
  static const IconData glossary = IconData(0xe901, fontFamily: _family, fontPackage: packageName);
  static const IconData grid = IconData(0xe973, fontFamily: _family, fontPackage: packageName);
  static const IconData headset = IconData(0xe9e3, fontFamily: _family, fontPackage: packageName);
  static const IconData history = IconData(0xe91a, fontFamily: _family, fontPackage: packageName);
  static const IconData home = IconData(0xe975, fontFamily: _family, fontPackage: packageName);
  static const IconData horn = IconData(0xe91b, fontFamily: _family, fontPackage: packageName);
  static const IconData hourglass = IconData(0xe9e4, fontFamily: _family, fontPackage: packageName);
  static const IconData how_do_I = IconData(0xe91c, fontFamily: _family, fontPackage: packageName);
  static const IconData ic_baseline_format_underlined = IconData(0xe91d, fontFamily: _family, fontPackage: packageName);
  static const IconData ic_baseline_strikethrough_s = IconData(0xe91e, fontFamily: _family, fontPackage: packageName);
  static const IconData ic_round_format_list_bulleted = IconData(0xe91f, fontFamily: _family, fontPackage: packageName);
  static const IconData ic_sharp_format_list_numbered = IconData(0xe920, fontFamily: _family, fontPackage: packageName);
  static const IconData image = IconData(0xe976, fontFamily: _family, fontPackage: packageName);
  static const IconData import = IconData(0xe9e5, fontFamily: _family, fontPackage: packageName);
  static const IconData inbox = IconData(0xe9e6, fontFamily: _family, fontPackage: packageName);
  static const IconData increase = IconData(0xe9a7, fontFamily: _family, fontPackage: packageName);
  static const IconData indicator_alert = IconData(0xe977, fontFamily: _family, fontPackage: packageName);
  static const IconData indicator_cancel = IconData(0xe978, fontFamily: _family, fontPackage: packageName);
  static const IconData indicator_check = IconData(0xe979, fontFamily: _family, fontPackage: packageName);
  static const IconData indicator_help = IconData(0xe97a, fontFamily: _family, fontPackage: packageName);
  static const IconData indicator_info = IconData(0xe97b, fontFamily: _family, fontPackage: packageName);
  static const IconData info = IconData(0xe921, fontFamily: _family, fontPackage: packageName);
  static const IconData keyboard = IconData(0xe9e7, fontFamily: _family, fontPackage: packageName);
  static const IconData launch = IconData(0xe922, fontFamily: _family, fontPackage: packageName);
  static const IconData lightbulb = IconData(0xe9e8, fontFamily: _family, fontPackage: packageName);
  static const IconData link = IconData(0xe97d, fontFamily: _family, fontPackage: packageName);
  static const IconData link_add = IconData(0xe97c, fontFamily: _family, fontPackage: packageName);
  static const IconData list_bullet = IconData(0xe97f, fontFamily: _family, fontPackage: packageName);
  static const IconData list_bullet_contained = IconData(0xe97e, fontFamily: _family, fontPackage: packageName);
  static const IconData list_details = IconData(0xe980, fontFamily: _family, fontPackage: packageName);
  static const IconData list_feedback = IconData(0xe981, fontFamily: _family, fontPackage: packageName);
  static const IconData list_form = IconData(0xe982, fontFamily: _family, fontPackage: packageName);
  static const IconData list_task = IconData(0xe983, fontFamily: _family, fontPackage: packageName);
  static const IconData location = IconData(0xe9ea, fontFamily: _family, fontPackage: packageName);
  static const IconData location_off = IconData(0xe9e9, fontFamily: _family, fontPackage: packageName);
  static const IconData lock = IconData(0xe985, fontFamily: _family, fontPackage: packageName);
  static const IconData lock_undo = IconData(0xe984, fontFamily: _family, fontPackage: packageName);
  static const IconData maintenance = IconData(0xe9eb, fontFamily: _family, fontPackage: packageName);
  static const IconData mdi_format_bold = IconData(0xe923, fontFamily: _family, fontPackage: packageName);
  static const IconData mdi_format_italic = IconData(0xe924, fontFamily: _family, fontPackage: packageName);
  static const IconData mdi_redo_variant = IconData(0xe925, fontFamily: _family, fontPackage: packageName);
  static const IconData mdi_undo_variant = IconData(0xe926, fontFamily: _family, fontPackage: packageName);
  static const IconData meal = IconData(0xe9ec, fontFamily: _family, fontPackage: packageName);
  static const IconData menu = IconData(0xe927, fontFamily: _family, fontPackage: packageName);
  static const IconData message_read = IconData(0xe928, fontFamily: _family, fontPackage: packageName);
  static const IconData mic = IconData(0xe9ed, fontFamily: _family, fontPackage: packageName);
  static const IconData minus = IconData(0xe987, fontFamily: _family, fontPackage: packageName);
  static const IconData mode_dark = IconData(0xe988, fontFamily: _family, fontPackage: packageName);
  static const IconData mode_light = IconData(0xe989, fontFamily: _family, fontPackage: packageName);
  static const IconData money = IconData(0xe929, fontFamily: _family, fontPackage: packageName);
  static const IconData more_hori = IconData(0xe98a, fontFamily: _family, fontPackage: packageName);
  static const IconData more_vert = IconData(0xe92a, fontFamily: _family, fontPackage: packageName);
  static const IconData mywork = IconData(0xe950, fontFamily: _family, fontPackage: packageName);
  static const IconData navigate = IconData(0xe9ee, fontFamily: _family, fontPackage: packageName);
  static const IconData negative = IconData(0xe92b, fontFamily: _family, fontPackage: packageName);
  static const IconData new_message = IconData(0xe92c, fontFamily: _family, fontPackage: packageName);
  static const IconData note = IconData(0xe98c, fontFamily: _family, fontPackage: packageName);
  static const IconData notification = IconData(0xe92d, fontFamily: _family, fontPackage: packageName);
  static const IconData notification_silence = IconData(0xe95f, fontFamily: _family, fontPackage: packageName);
  static const IconData notifications_off = IconData(0xe948, fontFamily: _family, fontPackage: packageName);
  static const IconData notifications_off_outlined = IconData(0xe92f, fontFamily: _family, fontPackage: packageName);
  static const IconData open_in_small = IconData(0xe95e, fontFamily: _family, fontPackage: packageName);
  static const IconData open_new = IconData(0xe9f1, fontFamily: _family, fontPackage: packageName);
  static const IconData open_new_off = IconData(0xe9f0, fontFamily: _family, fontPackage: packageName);
  static const IconData open_shift = IconData(0xe962, fontFamily: _family, fontPackage: packageName);
  static const IconData org = IconData(0xe99d, fontFamily: _family, fontPackage: packageName);
  static const IconData palette = IconData(0xe9f2, fontFamily: _family, fontPackage: packageName);
  static const IconData paper = IconData(0xe98d, fontFamily: _family, fontPackage: packageName);
  static const IconData partially_approved = IconData(0xe95a, fontFamily: _family, fontPackage: packageName);
  static const IconData partner = IconData(0xe9f3, fontFamily: _family, fontPackage: packageName);
  static const IconData pdf = IconData(0xe930, fontFamily: _family, fontPackage: packageName);
  static const IconData person_assign = IconData(0xe9f4, fontFamily: _family, fontPackage: packageName);
  static const IconData person_clock = IconData(0xe9f5, fontFamily: _family, fontPackage: packageName);
  static const IconData person_info = IconData(0xe9f6, fontFamily: _family, fontPackage: packageName);
  static const IconData person_manager = IconData(0xe9f7, fontFamily: _family, fontPackage: packageName);
  static const IconData person_move = IconData(0xe9f8, fontFamily: _family, fontPackage: packageName);
  static const IconData person_swap = IconData(0xe9f9, fontFamily: _family, fontPackage: packageName);
  static const IconData person_walk = IconData(0xe9fa, fontFamily: _family, fontPackage: packageName);
  static const IconData phone = IconData(0xe9fb, fontFamily: _family, fontPackage: packageName);
  static const IconData pin = IconData(0xe931, fontFamily: _family, fontPackage: packageName);
  static const IconData pinboard = IconData(0xe951, fontFamily: _family, fontPackage: packageName);
  static const IconData plus = IconData(0xe98f, fontFamily: _family, fontPackage: packageName);
  static const IconData point_gift = IconData(0xe9fc, fontFamily: _family, fontPackage: packageName);
  static const IconData point_heart = IconData(0xe9fd, fontFamily: _family, fontPackage: packageName);
  static const IconData point_money = IconData(0xe9fe, fontFamily: _family, fontPackage: packageName);
  static const IconData point_star = IconData(0xe9ff, fontFamily: _family, fontPackage: packageName);
  static const IconData point_token = IconData(0xea00, fontFamily: _family, fontPackage: packageName);
  static const IconData positive = IconData(0xe932, fontFamily: _family, fontPackage: packageName);
  static const IconData preview = IconData(0xe933, fontFamily: _family, fontPackage: packageName);
  static const IconData print = IconData(0xe990, fontFamily: _family, fontPackage: packageName);
  static const IconData profile = IconData(0xea01, fontFamily: _family, fontPackage: packageName);
  static const IconData project = IconData(0xe934, fontFamily: _family, fontPackage: packageName);
  static const IconData publish = IconData(0xea02, fontFamily: _family, fontPackage: packageName);
  static const IconData qchat = IconData(0xe952, fontFamily: _family, fontPackage: packageName);
  static const IconData qcheck = IconData(0xe954, fontFamily: _family, fontPackage: packageName);
  static const IconData qdocs = IconData(0xe955, fontFamily: _family, fontPackage: packageName);
  static const IconData qforms = IconData(0xe956, fontFamily: _family, fontPackage: packageName);
  static const IconData qnote = IconData(0xe94b, fontFamily: _family, fontPackage: packageName);
  static const IconData qnote_expired = IconData(0xe94e, fontFamily: _family, fontPackage: packageName);
  static const IconData qnotes = IconData(0xe957, fontFamily: _family, fontPackage: packageName);
  static const IconData qr = IconData(0xea03, fontFamily: _family, fontPackage: packageName);
  static const IconData qrcode = IconData(0xe94a, fontFamily: _family, fontPackage: packageName);
  static const IconData qstar = IconData(0xe958, fontFamily: _family, fontPackage: packageName);
  static const IconData queue = IconData(0xe991, fontFamily: _family, fontPackage: packageName);
  static const IconData qvisual = IconData(0xe959, fontFamily: _family, fontPackage: packageName);
  static const IconData radio_off = IconData(0xe992, fontFamily: _family, fontPackage: packageName);
  static const IconData radio_on = IconData(0xe993, fontFamily: _family, fontPackage: packageName);
  static const IconData rar = IconData(0xe953, fontFamily: _family, fontPackage: packageName);
  static const IconData react_add = IconData(0xea04, fontFamily: _family, fontPackage: packageName);
  static const IconData react_angry = IconData(0xea05, fontFamily: _family, fontPackage: packageName);
  static const IconData react_thumbsdown = IconData(0xea06, fontFamily: _family, fontPackage: packageName);
  static const IconData react_thumbsup = IconData(0xea07, fontFamily: _family, fontPackage: packageName);
  static const IconData reassign = IconData(0xe947, fontFamily: _family, fontPackage: packageName);
  static const IconData recall = IconData(0xe994, fontFamily: _family, fontPackage: packageName);
  static const IconData refresh = IconData(0xe995, fontFamily: _family, fontPackage: packageName);
  static const IconData reorder = IconData(0xe996, fontFamily: _family, fontPackage: packageName);
  static const IconData repeat = IconData(0xe997, fontFamily: _family, fontPackage: packageName);
  static const IconData report = IconData(0xe935, fontFamily: _family, fontPackage: packageName);
  static const IconData reset = IconData(0xe998, fontFamily: _family, fontPackage: packageName);
  static const IconData review = IconData(0xe936, fontFamily: _family, fontPackage: packageName);
  static const IconData sales = IconData(0xe937, fontFamily: _family, fontPackage: packageName);
  static const IconData save = IconData(0xea08, fontFamily: _family, fontPackage: packageName);
  static const IconData schedule = IconData(0xe938, fontFamily: _family, fontPackage: packageName);
  static const IconData scheduling = IconData(0xe99e, fontFamily: _family, fontPackage: packageName);
  static const IconData search = IconData(0xe939, fontFamily: _family, fontPackage: packageName);
  static const IconData search_advance = IconData(0xe949, fontFamily: _family, fontPackage: packageName);
  static const IconData security = IconData(0xe92e, fontFamily: _family, fontPackage: packageName);
  static const IconData send = IconData(0xe93a, fontFamily: _family, fontPackage: packageName);
  static const IconData settings_gear = IconData(0xe99b, fontFamily: _family, fontPackage: packageName);
  static const IconData settings_tune = IconData(0xe99c, fontFamily: _family, fontPackage: packageName);
  static const IconData share = IconData(0xea0b, fontFamily: _family, fontPackage: packageName);
  static const IconData share_file = IconData(0xea0a, fontFamily: _family, fontPackage: packageName);
  static const IconData sign_out = IconData(0xe93b, fontFamily: _family, fontPackage: packageName);
  static const IconData sm = IconData(0xe95b, fontFamily: _family, fontPackage: packageName);
  static const IconData sort = IconData(0xe93c, fontFamily: _family, fontPackage: packageName);
  static const IconData sphere = IconData(0xe9c9, fontFamily: _family, fontPackage: packageName);
  static const IconData star = IconData(0xe93d, fontFamily: _family, fontPackage: packageName);
  static const IconData start_outlined = IconData(0xe946, fontFamily: _family, fontPackage: packageName);
  static const IconData store = IconData(0xea0d, fontFamily: _family, fontPackage: packageName);
  static const IconData store_swap = IconData(0xea0c, fontFamily: _family, fontPackage: packageName);
  static const IconData subscription = IconData(0xe9a4, fontFamily: _family, fontPackage: packageName);
  static const IconData summary = IconData(0xe93e, fontFamily: _family, fontPackage: packageName);
  static const IconData support = IconData(0xe93f, fontFamily: _family, fontPackage: packageName);
  static const IconData surveys = IconData(0xe99f, fontFamily: _family, fontPackage: packageName);
  static const IconData switch_arrows = IconData(0xe9a0, fontFamily: _family, fontPackage: packageName);
  static const IconData sync = IconData(0xe9a1, fontFamily: _family, fontPackage: packageName);
  static const IconData synchronize = IconData(0xe940, fontFamily: _family, fontPackage: packageName);
  static const IconData tag = IconData(0xe941, fontFamily: _family, fontPackage: packageName);
  static const IconData task = IconData(0xe942, fontFamily: _family, fontPackage: packageName);
  static const IconData taskmanager = IconData(0xe9a2, fontFamily: _family, fontPackage: packageName);
  static const IconData tiers = IconData(0xe98e, fontFamily: _family, fontPackage: packageName);
  static const IconData timecard = IconData(0xe999, fontFamily: _family, fontPackage: packageName);
  static const IconData timecard_approve = IconData(0xea0e, fontFamily: _family, fontPackage: packageName);
  static const IconData timecard_warning = IconData(0xea0f, fontFamily: _family, fontPackage: packageName);
  static const IconData toggle_off = IconData(0xec1f, fontFamily: _family, fontPackage: packageName);
  static const IconData toggle_on = IconData(0xe9a6, fontFamily: _family, fontPackage: packageName);
  static const IconData translation = IconData(0xe9a3, fontFamily: _family, fontPackage: packageName);
  static const IconData trash = IconData(0xe9a8, fontFamily: _family, fontPackage: packageName);
  static const IconData unclaim = IconData(0xe943, fontFamily: _family, fontPackage: packageName);
  static const IconData unsubscribe = IconData(0xe9a5, fontFamily: _family, fontPackage: packageName);
  static const IconData update = IconData(0xe9aa, fontFamily: _family, fontPackage: packageName);
  static const IconData upload = IconData(0xea11, fontFamily: _family, fontPackage: packageName);
  static const IconData user = IconData(0xea15, fontFamily: _family, fontPackage: packageName);
  static const IconData user_add = IconData(0xea12, fontFamily: _family, fontPackage: packageName);
  static const IconData user_group = IconData(0xea13, fontFamily: _family, fontPackage: packageName);
  static const IconData user_multiple = IconData(0xea14, fontFamily: _family, fontPackage: packageName);
  static const IconData vacation = IconData(0xea16, fontFamily: _family, fontPackage: packageName);
  static const IconData verified = IconData(0xea17, fontFamily: _family, fontPackage: packageName);
  static const IconData video = IconData(0xe974, fontFamily: _family, fontPackage: packageName);
  static const IconData walk = IconData(0xe986, fontFamily: _family, fontPackage: packageName);
  static const IconData wifi = IconData(0xea18, fontFamily: _family, fontPackage: packageName);
  static const IconData write = IconData(0xe9ac, fontFamily: _family, fontPackage: packageName);
  static const IconData file_xlsm = IconData(0xe9ae, fontFamily: _family, fontPackage: packageName);
}

const Map<String, IconData> _extensions = <String, IconData>{
  '.au': ZdsIcons.file_audio_o,
  '.avi': ZdsIcons.file_video_o,
  '.csv': ZdsIcons.file_text_o,
  '.doc': ZdsIcons.file_word_o,
  '.docx': ZdsIcons.file_word_o,
  '.flv': ZdsIcons.file_video_o,
  '.gif': ZdsIcons.file_image_o,
  '.htm': ZdsIcons.file_o,
  '.ico': ZdsIcons.file_image_o,
  '.jpg': ZdsIcons.file_image_o,
  '.jpeg': ZdsIcons.file_image_o,
  '.m4v': ZdsIcons.file_video_o,
  '.midi': ZdsIcons.file_audio_o,
  '.mov': ZdsIcons.file_video_o,
  '.mp3': ZdsIcons.file_audio_o,
  '.mp4': ZdsIcons.file_video_o,
  '.mpg': ZdsIcons.file_video_o,
  '.mpeg': ZdsIcons.file_video_o,
  '.pdf': ZdsIcons.file_pdf_o,
  '.png': ZdsIcons.file_image_o,
  '.bmp': ZdsIcons.file_image_o,
  '.ppt': ZdsIcons.file_powerpoint_o,
  '.pptx': ZdsIcons.file_powerpoint_o,
  '.qt': ZdsIcons.file_o,
  '.rar': ZdsIcons.file_archive_o,
  '.rtf': ZdsIcons.file_text_o,
  '.tif': ZdsIcons.file_image_o,
  '.tiff': ZdsIcons.file_image_o,
  '.ttf': ZdsIcons.file_o,
  '.txt': ZdsIcons.file_text_o,
  '.wav': ZdsIcons.file_audio_o,
  '.xls': ZdsIcons.file_excel_o,
  '.xlsx': ZdsIcons.file_excel_o,
  '.xlsm': ZdsIcons.file_xlsm,
  '.xml': ZdsIcons.file_excel_o,
  '.zip': ZdsIcons.file_archive_o,
  '.url': ZdsIcons.file_o,
};

/// Gets icon color based on file extension.
///
/// If `context` is not null, this will use colors from [ZetaColors].
///
/// Otherwise:
/// Text Documents: #376FC9
/// PDF & PPT (distinguished as they are commonly used): #DB0D00
/// Images: #F56200
/// Video: #6F00C6
/// Audio: #70A300
/// Spreadsheets: #1F802E
/// Misc: #888888
Color iconColor(String ext, {BuildContext? context}) {
  final String ext1;
  if (!ext.contains('.')) {
    ext1 = '.$ext';
  } else if (ext.split('.').length > 2) {
    ext1 = ".${ext.split('.').last}";
  } else {
    ext1 = ext;
  }
  switch (ext1) {
    case '.doc':
    case '.docx':
    case '.rtf':
    case '.ttf':
    case '.txt':
      if (context != null) return Zeta.of(context).colors.blue;
      return '#376FC9'.colorFromHex();

    case '.pdf':
    case '.ppt':
    case '.pptx':
      if (context != null) return Zeta.of(context).colors.red;
      return '#DB0D00'.colorFromHex();

    case '.gif':
    case '.ico':
    case '.jpg':
    case '.jpeg':
    case '.png':
    case '.tif':
    case '.tiff':
    case '.bmp':
      if (context != null) return Zeta.of(context).colors.orange;
      return '#F56200'.colorFromHex();

    case '.flv':
    case '.m4v':
    case '.mov':
    case '.mpeg':
    case '.mpg':
    case '.qt':
      if (context != null) return Zeta.of(context).colors.purple;
      return '#6F00C6'.colorFromHex();

    case '.au':
    case '.avi':
    case '.midi':
    case '.mp3':
    case '.mp4':
    case '.wav':
      if (context != null) return Zeta.of(context).colors.teal;
      return '#70A300'.colorFromHex();

    case '.csv':
    case '.xml':
    case '.xls':
    case '.xlsx':
      if (context != null) return Zeta.of(context).colors.green;
      return '#1F802E'.colorFromHex();

    case '.htm':
    case '.rar':
    case '.url':
    case '.zip':
      if (context != null) return Zeta.of(context).colors.warm;

      return '#888888'.colorFromHex();

    default:
      return '#888888'.colorFromHex();
  }
}

IconData extensionIcon(String ext) {
  final String ext1;
  if (!ext.contains('.')) {
    ext1 = '.$ext';
  } else if (ext.split('.').length > 2) {
    ext1 = ".${ext.split('.').last}";
  } else {
    ext1 = ext;
  }
  return _extensions[ext1] ?? ZdsIcons.file_o;
}

extension IconDataFromExt on String {
  /// Assuming the string is a file name, this function returns the corresponding icon for the filetype.
  ///
  /// Here the icon for an image will be returned
  ///
  /// ```dart
  ///  Icon(
  ///    'example.jpg'.fileIcon(),
  ///    color: ZdsColors.green,
  ///    size: 24.0,
  ///    semanticLabel: 'Text to announce in accessibility modes',
  ///  )
  /// ```
  ///
  /// If the string does not contain a file type, or contains an unrecognized filetype, [ZdsIcons.file_o] will be returned.
  IconData fileIcon() {
    return _resolveFileIcon(this);
  }

  Icon coloredFileIcon() {
    return Icon(_resolveFileIcon(this), color: _resolveFileColor(this));
  }
}

IconData _resolveFileIcon(String? name) {
  if (name == null) return ZdsIcons.file_o;
  final String ext = path.extension(name).toLowerCase();
  return _extensions[ext] ?? ZdsIcons.file_o;
}

Color? _resolveFileColor(String? name) {
  if (name == null) return null;
  final String ext = path.extension(name).toLowerCase();
  return iconColor(ext);
}
