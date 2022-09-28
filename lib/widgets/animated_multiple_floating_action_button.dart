import 'package:flutter/material.dart';

class AnimatedMultipleFloatingActionButton extends StatefulWidget {

  final Function() onPressed;
  final String tooltip;
  final AnimatedIconData? animatedIconData;
  final List<Widget> childrens;
  final Color? iconOpenColor;
  final Color? iconCloseColor;
  final Duration? durationOfAnimationToOpenClose;
  
  const AnimatedMultipleFloatingActionButton({
    Key? key, required this.onPressed, 
    required this.tooltip, 
    this.animatedIconData, 
    required this.childrens, 
    this.iconOpenColor, 
    this.iconCloseColor, 
    this.durationOfAnimationToOpenClose,
  }) : super(key: key);

  @override
  State<AnimatedMultipleFloatingActionButton> createState() => _AnimatedMultipleFloatingActionButtonState();
}

class _AnimatedMultipleFloatingActionButtonState extends State<AnimatedMultipleFloatingActionButton> with SingleTickerProviderStateMixin {

  bool isOpened = false;
  late AnimationController _animationController;
  late Animation<Color?> _buttonColor;
  late Animation<double> _animateIcon;
  late Animation<double> _translateButton;
  final Curve _curve = Curves.easeOut;
  final double _fabHeight = 56.0;

  @override
  initState() {

    _animationController =AnimationController(vsync: this, duration: widget.durationOfAnimationToOpenClose ?? const Duration(milliseconds: 500))
    ..addListener(() {
      setState(() {});
    });

    _animateIcon = Tween<double>(
      begin: 0.0, 
      end: 1.0
    ).animate(
      _animationController
    );

    _buttonColor = ColorTween(
      begin: widget.iconOpenColor ?? Colors.blue,
      end: widget.iconCloseColor ?? Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(
        0.00,
        1.00,
        curve: Curves.linear,
      ),
    ));

    _translateButton = Tween<double>(
      begin: _fabHeight,
      end: -5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.0,
        0.75,
        curve: _curve,
      ),
    ));

    super.initState();
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }

 
  Widget toggle() {
    return FloatingActionButton(
      backgroundColor: _buttonColor.value,
      onPressed: animate,
      tooltip: widget.tooltip,
      child: AnimatedIcon(
        icon: widget.animatedIconData ?? AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  List<Widget>childrens() {

    List<Widget> widgets = [];

    for (var i = 0; i < widget.childrens.length; i++) 
    {
      widgets.add(Transform(
        transform: Matrix4.translationValues(
          0.0,
          _translateButton.value * (i + 1),
          0.0,
        ),
        child: widget.childrens.elementAt(i),
      ));

    }

    return widgets.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ...childrens(),
        toggle(),
      ]
    );
  }
}

