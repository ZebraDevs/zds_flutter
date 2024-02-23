import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../zds_flutter.dart';

/// Row at bottom of chat message that shows tags and reacts.
class ReactTagsRow extends StatelessWidget {
  /// Constructor for [ReactTagsRow].
  const ReactTagsRow({
    required this.reacts,
    required this.tags,
    required this.onTagTapped,
    required this.onReactTapped,
    super.key,
    this.reverse = false,
  });

  /// Map of reacts to number of times sent.
  final Map<String, int> reacts;

  /// List of tags attributed to message.
  final List<String> tags;

  /// Called when tag pill is tapped.
  final VoidCallback? onTagTapped;

  /// Called when react pill is tapped.
  final VoidCallback? onReactTapped;

  /// Reverses direction of pills, based on if message is shown on left or right.
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    final bool hasTags = tags.isNotEmpty;
    final bool hasReacts = reacts.values.any((element) => element != 0);

    final List<Widget> widgets = [
      if (hasTags) _ChatTagsPill(tags: tags, onTap: onTagTapped),
      if (hasTags && hasReacts) const SizedBox(width: 6),
      if (hasReacts) _ChatReactionsPill(onTap: onReactTapped, reactions: reacts),
    ];

    return Row(
      children: reverse ? widgets.reversed.toList() : widgets,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Map<String, int>?>('reactInfo', reacts))
      ..add(ObjectFlagProperty<void Function()?>.has('onTagTapped', onTagTapped))
      ..add(ObjectFlagProperty<void Function()?>.has('onReactTapped', onReactTapped))
      ..add(DiagnosticsProperty<bool>('reverse', reverse))
      ..add(IterableProperty<String>('tags', tags));
  }
}

/// Displays the top reactions in a pill. See [ZdsChatMessage].
class _ChatReactionsPill extends StatelessWidget {
  /// Constructs a [_ChatReactionsPill].
  const _ChatReactionsPill({
    required this.reactions,
    this.onTap,
  });

  /// Key Value pair where keys are the reactions, and the value is the number of times it has been sent.
  final Map<String, int> reactions;

  /// Called when widget is tapped.
  final VoidCallback? onTap;

  String _getReactionsAmount(Map<String, int> reactionInfo) {
    int reactionAmount = 0;
    reactionInfo.forEach((key, value) {
      if (value > 0) {
        reactionAmount += value;
      }
    });

    return reactionAmount.toString();
  }

  Map<String, int> _filterReactions(Map<String, int> reactionInfo) {
    reactionInfo.removeWhere((key, value) => value <= 0);
    return reactionInfo;
  }

  @override
  Widget build(BuildContext context) {
    final reactionInfo = _filterReactions(reactions);
    if (reactionInfo.isEmpty) return const SizedBox.shrink();
    final trimmedReacts = _trimReactionInfo(reactionInfo);
    final String reactionsAmount = _getReactionsAmount(reactionInfo);
    final zetaColors = Zeta.of(context).colors;
    return GestureDetector(
      onTap: onTap,
      child: Semantics(
        onTapHint: ComponentStrings.of(context).get('OPEN_REACTS', 'open reacts'),
        label: reactionInfo.entries.length > 1
            ? ComponentStrings.of(context).get('REACTIONS', 'reactions')
            : ComponentStrings.of(context).get('REACTION', 'reaction'),
        focusable: true,
        button: true,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [BoxShadow(color: zetaColors.shadow, blurRadius: 1, offset: const Offset(0, 1))],
            color: zetaColors.surfacePrimary,
            border: Border.all(color: zetaColors.borderSubtle),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5, top: 4, bottom: 4, left: 6),
                child: Text(
                  _getReactText(trimmedReacts),
                  style: Theme.of(context).textTheme.bodySmall,
                  softWrap: false,
                ),
              ),
              if (int.parse(reactionsAmount) > 0)
                ExcludeSemantics(
                  child: Text(
                    reactionsAmount,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: zetaColors.textSubtle),
                  ),
                ),
              const SizedBox(width: 6),
            ],
          ),
        ),
      ),
    );
  }

  //Sorts the reaction info by most used react and returns the top two most used
  Map<String, int> _trimReactionInfo(Map<String, int> reactionInfo) {
    final sortedKeys = reactionInfo.keys.toList()
      ..sort((k1, k2) => (reactionInfo[k2]?.compareTo(reactionInfo[k1] ?? -1) ?? -1));

    final Map<String, int> sortedMap = {sortedKeys[0]: reactionInfo[sortedKeys[0]]!};

    if (sortedKeys.length > 1) {
      sortedMap[sortedKeys[1]] = reactionInfo[sortedKeys[1]]!;
    }

    return sortedMap;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Map<String, int>>('reactionInfo', reactions))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }

  String _getReactText(Map<String, int>? reactionInfo) {
    if (reactionInfo == null) {
      return '';
    }
    // Convert keys to integers and sort them in ascending order
    final sortedKeys = reactionInfo.keys.toList()..sort((a, b) => a.compareTo(b));

    // Map sorted keys to their corresponding reaction emojis
    return sortedKeys.map((key) => '${_getReactionEmoji(reactionInfo.keys.toList(), key)} ').join().trim();
  }

  String _getReactionEmoji(List<String> reactions, String key) {
    if (reactions.isNotEmpty) {
      final filterList = reactions.where((keyVal) => keyVal == key);
      if (filterList.isNotEmpty) return filterList.first;
    }
    return '';
  }
}

/// Displays count of tags in a pill. See [ZdsChatMessage].
class _ChatTagsPill extends StatelessWidget {
  /// Constructs a [_ChatTagsPill].
  const _ChatTagsPill({
    required this.tags,
    this.onTap,
  });

  /// List of tags attributed to message.
  final List<String> tags;

  /// Called when pill is tapped.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final zetaColors = Zeta.of(context).colors;

    return Semantics(
      label:
          '${tags.length}${tags.length > 1 ? ComponentStrings.of(context).get('TAGS', 'tags') : ComponentStrings.of(context).get('TAG', 'tag')}.',
      button: true,
      onTapHint: ComponentStrings.of(context).get('MODIFY_TAGS', 'Modify tags'),
      focusable: true,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: zetaColors.surfacePrimary),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [BoxShadow(color: zetaColors.shadow, blurRadius: 1, offset: const Offset(0, 1))],
            color: zetaColors.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            child: Row(
              children: [
                Icon(ZdsIcons.tag, size: 10, color: zetaColors.secondary.onColor),
                const SizedBox(width: 4),
                ExcludeSemantics(
                  child: Text(
                    tags.length < 10 ? tags.length.toString() : '9+',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: zetaColors.secondary.onColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<String>('tags', tags))
      ..add(ObjectFlagProperty<VoidCallback?>.has('onTap', onTap));
  }
}
