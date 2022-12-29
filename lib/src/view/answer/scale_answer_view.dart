import 'package:flutter/material.dart' hide Step;
import 'package:survey_kit/src/model/answer/scale_answer_format.dart';
import 'package:survey_kit/src/model/result/step_result.dart';
import 'package:survey_kit/src/model/step.dart';
import 'package:survey_kit/src/util/measure_date_state_mixin.dart';
import 'package:survey_kit/src/view/content/content_widget.dart';
import 'package:survey_kit/src/view/step_view.dart';

class ScaleAnswerView extends StatefulWidget {
  final Step questionStep;
  final StepResult? result;

  const ScaleAnswerView({
    Key? key,
    required this.questionStep,
    required this.result,
  }) : super(key: key);

  @override
  _ScaleAnswerViewState createState() => _ScaleAnswerViewState();
}

class _ScaleAnswerViewState extends State<ScaleAnswerView>
    with MeasureDateStateMixin {
  late final ScaleAnswerFormat _scaleAnswerFormat;
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    final answer = widget.questionStep.answer;
    if (answer == null) {
      throw Exception('ScaleAnswerFormat is null');
    }
    _scaleAnswerFormat = answer as ScaleAnswerFormat;
    _sliderValue =
        widget.result?.result as double? ?? _scaleAnswerFormat.defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    return StepView(
      step: widget.questionStep,
      resultFunction: () => StepResult<double>(
        id: widget.questionStep.id,
        startTime: startDate,
        endTime: DateTime.now(),
        valueIdentifier: _sliderValue.toString(),
        result: _sliderValue,
      ),
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(bottom: 32.0, left: 14.0, right: 14.0),
            child: ContentWidget(
              content: widget.questionStep.content,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Text(
                    _sliderValue.toInt().toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _scaleAnswerFormat.minimumValueDescription,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          Text(
                            _scaleAnswerFormat.maximumValueDescription,
                            style: const TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Slider.adaptive(
                      value: _sliderValue,
                      onChanged: (double value) {
                        setState(() {
                          _sliderValue = value;
                        });
                      },
                      min: _scaleAnswerFormat.minimumValue,
                      max: _scaleAnswerFormat.maximumValue,
                      activeColor: Theme.of(context).primaryColor,
                      divisions: (_scaleAnswerFormat.maximumValue -
                              _scaleAnswerFormat.minimumValue) ~/
                          _scaleAnswerFormat.step,
                      label: _sliderValue.toString(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}