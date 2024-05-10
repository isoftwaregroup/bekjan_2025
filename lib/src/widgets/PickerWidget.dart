import 'package:flutter/material.dart';

class PickerWidet extends StatefulWidget {
  final double itemWidth;
  final double itemHeight;
  int itemCount;
  final int currentIndex;
  Function(int index)? onChange;
  Widget Function(BuildContext context,int index, bool isSelected) builder;
  PickerWidet({
    Key? key,
    required this.itemWidth,
    required this.itemHeight,
    required this.itemCount,
    required this.builder,
    this.onChange,
    this.currentIndex = 0,
  }) : assert(itemWidth > 0),
        assert(itemHeight > 0),
        assert(itemCount > 0),
        super(key: key);

  @override
  State<PickerWidet> createState() => _PickerWidetState();
}

class _PickerWidetState extends State<PickerWidet> {
  int _currentValue = 0;
  int _lastValue = 0;
  late ScrollController _scrollController;
  bool get isScrolling => _scrollController.position.isScrollingNotifier.value;

  @override
  void initState() {
    _scrollController = ScrollController(initialScrollOffset: 0);
    _scrollController.addListener(_scrollListener);
    setState(() {
      _currentValue = widget.currentIndex;
      if(_currentValue > 0){
        _currentValue--;
        setCurrent();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.itemWidth,
      height: widget.itemHeight * 3,
      color: const Color(0x00000000),
      child: ListView.builder(
        itemCount: widget.itemCount + 2,
        scrollDirection: Axis.vertical,
        controller: _scrollController,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: widget.itemWidth,
            height: widget.itemHeight,
            alignment: Alignment.center,
            child: index == 0 || widget.itemCount + 1 == index
                ? const SizedBox()
                : widget.builder(context,index - 1,_currentValue + 1 == index),
          );
        },
        padding: EdgeInsets.zero,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    setState(() {
      if(widget.itemHeight == 0){
        _currentValue = 0;
      }else{
        int value = _scrollController.offset ~/ widget.itemHeight;
        if(_scrollController.offset - value * widget.itemHeight > widget.itemHeight / 2){
          value++;
        }
        _currentValue = value;
      }
    });
    if(_currentValue < widget.itemCount
        && _lastValue != _currentValue
        && widget.onChange != null
        && _currentValue >= 0){
      widget.onChange!(_currentValue);
      _lastValue = _currentValue;
    }
    Future.delayed(
      const Duration(milliseconds: 100),
          () => _setCenterScroll(),
    );
  }

  void _setCenterScroll() {
    if (_scrollController.hasClients && !isScrolling) {
      double animHeight = widget.itemHeight * _currentValue;
      if(_scrollController.offset > animHeight){
        animHeight = _scrollController.offset - animHeight;
      }else{
        animHeight = animHeight - _scrollController.offset;
      }
      if(animHeight > 0.000001 || _currentValue == 0){
        _scrollController.animateTo(
          widget.itemHeight * _currentValue,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  void setCurrent() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _scrollController.animateTo(
      _currentValue * widget.itemHeight,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }
}
