import 'package:flutter/material.dart';
import 'package:savyminds/constants.dart';
import 'package:savyminds/resources/app_gradients.dart';
import 'package:savyminds/screens/game/game/components/game_background.dart';

enum HalloaStepState {
  indexed,
  editing,
  complete,
  disabled,
  error,
}

enum HalloaStepperType {
  vertical,
  horizontal,
}

const TextStyle _kStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white38;
const double _kStepSize = 24.0;

@immutable
class HalloaStep {
  const HalloaStep({
    Key? key,
    required this.title,
    this.subtitle,
    required this.content,
    this.state = HalloaStepState.indexed,
    this.isActive = false,
  });

  final Widget title;

  final Widget? subtitle;

  final Widget content;

  final HalloaStepState state;

  final bool isActive;
}

class HalloaStepper extends StatefulWidget {
  const HalloaStepper({
    Key? key,
    required this.steps,
    this.physics,
    this.currentStep = 0,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  })  : assert(0 <= currentStep && currentStep < steps.length),
        super(key: key);

  final List<HalloaStep> steps;

  final ScrollPhysics? physics;

  final HalloaStepperType type = HalloaStepperType.horizontal;

  final int currentStep;

  final ValueChanged<int>? onStepTapped;

  final VoidCallback? onStepContinue;

  final VoidCallback? onStepCancel;

  final ControlsWidgetBuilder? controlsBuilder;

  @override
  StepperState createState() => StepperState();
}

class StepperState extends State<HalloaStepper> with TickerProviderStateMixin {
  final Map<int, HalloaStepState> _oldStates = <int, HalloaStepState>{};

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didUpdateWidget(HalloaStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final HalloaStepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    switch (state) {
      case HalloaStepState.indexed:
      case HalloaStepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kStepStyle.copyWith(color: Colors.black87)
              : _kStepStyle,
        );
      case HalloaStepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case HalloaStepState.complete:
        return Icon(
          Icons.check,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case HalloaStepState.error:
        return const Text('!', style: _kStepStyle);
    }
  }

  Color _circleColor(int index, bool oldState) {
    final HalloaStepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    switch (state) {
      case HalloaStepState.indexed:
      case HalloaStepState.disabled:
        return Colors.grey;
      case HalloaStepState.editing:
        return Colors.red;
      case HalloaStepState.complete:
        return Colors.green;
      case HalloaStepState.error:
        return Colors.blue;
    }
  }

  Widget _buildCircle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kStepSize,
      height: _kStepSize,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index,
              oldState && widget.steps[index].state == HalloaStepState.error),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: _buildCircleChild(index,
              oldState && widget.steps[index].state == HalloaStepState.error),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildCircle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == HalloaStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != HalloaStepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildCircle(index, false);
      }
    }
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    switch (widget.steps[index].state) {
      case HalloaStepState.indexed:
      case HalloaStepState.editing:
      case HalloaStepState.complete:
        return textTheme.bodyLarge!;
      case HalloaStepState.disabled:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kDisabledDark : _kDisabledLight,
        );
      case HalloaStepState.error:
        return textTheme.bodyLarge!.copyWith(
          color: _isDark() ? _kErrorDark : _kErrorLight,
        );
    }
  }

  Widget _buildHeaderText(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AnimatedDefaultTextStyle(
          style: _titleStyle(index),
          duration: kThemeAnimationDuration,
          curve: Curves.fastOutSlowIn,
          child: widget.steps[index].title,
        ),
        if (widget.steps[index].subtitle != null)
          Container(
            margin: const EdgeInsets.only(top: 2.0),
            child: AnimatedDefaultTextStyle(
              style: const TextStyle(),
              duration: kThemeAnimationDuration,
              curve: Curves.fastOutSlowIn,
              child: widget.steps[index].subtitle!,
            ),
          ),
      ],
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap: widget.steps[i].state != HalloaStepState.disabled
              ? () {
                  widget.onStepTapped?.call(i);
                }
              : null,
          canRequestFocus: widget.steps[i].state != HalloaStepState.disabled,
          child: SizedBox(
            height: d.pSH(40),
            child: Row(
              children: <Widget>[
                SizedBox(
                  child: Center(
                    child: _buildIcon(i),
                  ),
                ),
                Container(
                  margin: const EdgeInsetsDirectional.only(start: 12.0),
                  child: _buildHeaderText(i),
                ),
              ],
            ),
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.black,
            ),
          ),
      ],
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          GameBackground(
            backgroundGradient: AppGradients.landingGradient,
          ),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: d.pSW(200),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: children,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      widget.steps[widget.currentStep].content,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    assert(() {
      if (context.findAncestorWidgetOfExactType<Stepper>() != null) {
        throw FlutterError(
          '',
        );
      }
      return true;
    }());
    switch (widget.type) {
      case HalloaStepperType.vertical:
        return _buildHorizontal();
      case HalloaStepperType.horizontal:
        return _buildHorizontal();
    }
  }
}
