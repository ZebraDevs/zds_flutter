import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';

import '../../../utils/assets/icons.dart';
import '../../../utils/localizations/translation.dart';
import '../../../utils/tools/utils.dart';
import '../../molecules/empty.dart';
import '../../molecules/search.dart';

/// A widget to pick Giphy images.
///
/// Displays a collection of Giphy images based on the query provided
/// by the user. The user can select a GIF from the displayed collection.

class ZdsGiphyPicker extends StatefulWidget {
  /// Creates a [ZdsGiphyPicker] widget.
  ///
  /// The [key] parameter is optional and is used to control the framework's
  /// widget replacement and state synchronization mechanisms.
  const ZdsGiphyPicker({super.key, required this.apiKey, this.allowMultiple = false});

  /// API Key, required to use giphy service.
  ///
  /// See [Giphy Developers](https://developers.giphy.com/).
  final String apiKey;

  /// Check for allowing multiple files or not
  final bool allowMultiple;

  @override
  State<ZdsGiphyPicker> createState() => _ZdsGiphyPickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(StringProperty('apiKey', apiKey))
      ..add(DiagnosticsProperty<bool>('allowMultiple', allowMultiple));
  }
}

class _ZdsGiphyPickerState extends State<ZdsGiphyPicker> {
  // is Loading gifs
  bool _isLoading = false;

  /// Represents a collection of Giphy GIFs.
  GiphyCollection? _collection;

  /// Text for querying GIFs.
  String _queryText = '';

  /// Contains the list of fetched GIFs.
  final List<GiphyGif> _list = <GiphyGif>[];

  /// Maximum number of GIFs to query at once.
  late int _limit;

  /// The next GIF in the collection to retrieve.
  int offset = 0;

  /// Controller to manage scroll behavior.
  ScrollController scrollController = ScrollController();

  /// Controller to manage the search text.
  final TextEditingController _searchController = TextEditingController();

  /// Timer used to debounce search queries.
  Timer? _debounce;

  /// Delay before the debounce effect takes place.
  late Duration debounceDelay;

  List<GiphyGif> selectedGIFs = [];

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });

    scrollController.addListener(_loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    const double gifWidth = 80;

    scrollController.addListener(_loadMore);

    // Set items count responsive
    final int crossAxisCount = (MediaQuery.of(context).size.width / gifWidth).round();

    // Set vertical max items count
    final int mainAxisCount = ((MediaQuery.of(context).size.height - 30) / gifWidth).round();

    _limit = crossAxisCount * mainAxisCount;
    if (_limit > 100) _limit = 100;
    // Initial offset
    offset = 0;

    // Load Initial Data
    unawaited(_loadMore());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IconButton? clearButton = _searchController.text.isNotEmpty
        ? IconButton(
            icon: const Icon(ZdsIcons.close_circle),
            onPressed: () {
              _searchController.clear();
              _queryText = '';
              _listenerQuery();
            },
          )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(ComponentStrings.of(context).get('PICK_GIF', 'Pick a Gif')),
        actions: widget.allowMultiple
            ? [
                TextButton(
                  onPressed: selectedGIFs.isNotEmpty
                      ? () {
                          Navigator.pop(context, selectedGIFs);
                        }
                      : null,
                  child: Text(ComponentStrings.of(context).get('ADD', 'Add')),
                ),
              ]
            : [],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints box) {
          return Column(
            children: <Widget>[
              ZdsSearchField(
                hintText: ComponentStrings.of(context).get('SEARCH_GIF', 'Search all the GIFs'),
                suffixIcon: clearButton,
                controller: _searchController,
                onChange: (String value) {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce = Timer(const Duration(milliseconds: 500), () async {
                    setState(() {
                      _queryText = value;
                      _listenerQuery();
                    });
                  });
                },
              ),
              if (_isLoading && _list.isEmpty)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (_list.isNotEmpty)
                Expanded(
                  child: GridView.builder(
                    itemCount: _list.length,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: box.maxWidth > 500 ? 200 : 100,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                    ),
                    itemBuilder: (BuildContext ctx, int idx) => _item(ctx, _list[idx]),
                  ),
                )
              else
                const ZdsEmpty(),
            ],
          );
        },
      ),
    );
  }

  Widget _item(BuildContext context, GiphyGif gif) {
    final String? url = gif.images?.previewWebp?.url;
    return InkWell(
      onTap: () {
        if (widget.allowMultiple) {
          _toggleCheckBox(gif);
        } else {
          Navigator.pop(context, [gif]);
        }
      },
      child: url == null
          ? Container()
          : Stack(
              alignment: Alignment.bottomRight,
              children: [
                ExtendedImage.network(
                  url,
                  semanticLabel: gif.title,
                  gaplessPlayback: true,
                  fit: BoxFit.fill,
                  headers: const <String, String>{'accept': 'image/*'},
                  loadStateChanged: (ExtendedImageState state) => AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: gif.images == null
                        ? Container()
                        : <LoadState, AspectRatio>{
                            LoadState.loading: AspectRatio(
                              aspectRatio: 1,
                              child: Container(color: Theme.of(context).cardColor),
                            ),
                            LoadState.completed: AspectRatio(
                              aspectRatio: 1,
                              child: ExtendedRawImage(fit: BoxFit.fill, image: state.extendedImageInfo?.image),
                            ),
                            LoadState.failed: AspectRatio(
                              aspectRatio: 1,
                              child: Container(color: Theme.of(context).cardColor),
                            ),
                          }.get(
                            state.extendedImageLoadState,
                            fallback: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                color: Theme.of(context).cardColor,
                              ),
                            ),
                          ),
                  ),
                ),
                if (widget.allowMultiple)
                  Checkbox(
                    value: selectedGIFs.contains(gif),
                    shape: const CircleBorder(),
                    onChanged: (bool? value) {
                      _toggleCheckBox(gif);
                    },
                    side: selectedGIFs.contains(gif)
                        ? const BorderSide(
                            color: Colors.red,
                            width: 2,
                          )
                        : BorderSide.none,
                  ),
              ],
            ),
    );
  }

  void _toggleCheckBox(GiphyGif gif) {
    setState(() {
      if (selectedGIFs.contains(gif)) {
        selectedGIFs.remove(gif);
      } else {
        selectedGIFs.add(gif);
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading || _collection?.pagination?.totalCount == _list.length) {
      return;
    }

    _isLoading = true;

    // Giphy Client from library
    final GiphyClient client = GiphyClient(apiKey: widget.apiKey, randomId: '');

    // Offset pagination for query
    if (_collection == null) {
      offset = 0;
    } else {
      offset = _collection!.pagination!.offset + _collection!.pagination!.count;
    }

    // If query text is not null search gif else trending
    if (_queryText.isNotEmpty) {
      _collection = await client.search(
        _queryText,
        lang: Localizations.localeOf(context).languageCode,
        offset: offset,
        limit: _limit,
      );
    } else {
      _collection = await client.trending(
        lang: Localizations.localeOf(context).languageCode,
        offset: offset,
        limit: _limit,
      );
    }

    // Set result to list
    if (_collection!.data.isNotEmpty && mounted) {
      setState(() {
        _list.addAll(_collection!.data);
      });
    }
    _isLoading = false;
  }

  // listener query
  void _listenerQuery() {
    // Reset pagination
    _collection = null;

    // Reset list
    _list.clear();

    // Load data
    unawaited(_loadMore());
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<Duration>('debounceDelay', debounceDelay))
      ..add(IntProperty('offset', offset))
      ..add(DiagnosticsProperty<ScrollController>('scrollController', scrollController))
      ..add(IterableProperty<GiphyGif>('selecetdGifs', selectedGIFs));
  }
}
