import 'dart:async';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:giphy_get/giphy_get.dart';

import '../../../../zds_flutter.dart';

/// See [ZdsFilePicker].
class ZdsGiphyPicker extends StatefulWidget {
  /// API Key, required to use giphy service.
  ///
  /// See https://developers.giphy.com/
  final String apiKey;

  /// See [ZdsFilePicker].
  const ZdsGiphyPicker({super.key, required this.apiKey});

  @override
  State<ZdsGiphyPicker> createState() => _ZdsGiphyPickerState();
  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('apiKey', apiKey));
  }
}

class _ZdsGiphyPickerState extends State<ZdsGiphyPicker> {
  // is Loading gifs
  bool _isLoading = false;

  // Collection
  GiphyCollection? _collection;

  String _queryText = '';

  // List of gifs
  final List<GiphyGif> _list = [];

  // Limit of query
  late int _limit;

  // Offset
  int offset = 0;

  ScrollController scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  bool _hasText = false;

  Timer? _debounce;
  late Duration debounceDelay;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
    });

    scrollController.addListener(_loadMore);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    const double gifWidth = 80;

    _searchController.addListener(() {
      setState(() {
        _hasText = _searchController.text.isNotEmpty;
      });
    });

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
    final clearButton = _hasText
        ? IconButton(
            icon: Icon(ZdsIcons.close_circle, color: ZdsColors.greySwatch(context)[800]),
            onPressed: () {
              _searchController.clear();
              _queryText = '';
              _listenerQuery();
            },
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(ComponentStrings.of(context).get('PICK_GIF', 'Pick a Gif'))),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          ZdsSearchField(
            hintText: ComponentStrings.of(context).get('SEARCH_GIF', 'Search all the GIFs'),
            suffixIcon: clearButton,
            controller: _searchController,
            onChange: (value) {
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
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemBuilder: (ctx, idx) {
                  return _item(ctx, _list[idx]);
                },
              ),
            )
          else
            const ZdsEmpty(),
        ],
      ),
    );
  }

  Widget _item(BuildContext context, GiphyGif gif) {
    return InkWell(
      onTap: () => Navigator.pop(context, gif),
      child: gif.images == null || gif.images?.fixedWidth.webp == null
          ? Container()
          : ExtendedImage.network(
              gif.images!.fixedWidth.webp!,
              semanticLabel: gif.title,
              gaplessPlayback: true,
              headers: const {'accept': 'image/*'},
              loadStateChanged: (state) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: gif.images == null
                    ? Container()
                    : {
                        LoadState.loading: AspectRatio(
                          aspectRatio: 1,
                          child: Container(color: Theme.of(context).cardColor),
                        ),
                        LoadState.completed: AspectRatio(
                          aspectRatio: 1,
                          child: ExtendedRawImage(fit: BoxFit.contain, image: state.extendedImageInfo?.image),
                        ),
                        LoadState.failed: AspectRatio(
                          aspectRatio: 1,
                          child: Container(color: Theme.of(context).cardColor),
                        ),
                      }.get(
                        state.extendedImageLoadState,
                        orDefault: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Theme.of(context).cardColor,
                          ),
                        ),
                      ),
              ),
            ),
    );
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
    properties.add(IntProperty('offset', offset));
    properties.add(DiagnosticsProperty<ScrollController>('scrollController', scrollController));
    properties.add(DiagnosticsProperty<Duration>('debounceDelay', debounceDelay));
  }
}
