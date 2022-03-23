import 'package:flutter/material.dart';
import 'package:live_analysis_tool/dto/project.dart';
import 'package:live_analysis_tool/services/project_service.dart';
import 'package:live_analysis_tool/components/auth_required_state.dart';

class RecordProjectPage extends StatefulWidget {
  final Project project;

  const RecordProjectPage({Key? key, required this.project}) : super(key: key);

  @override
  _RecordProjectPageState createState() => _RecordProjectPageState();
}

class _RecordProjectPageState extends AuthRequiredState<RecordProjectPage> {
  final _projectService = ProjectService();

  @override
  void initState() {
    super.initState();
  }

  void _start() {
    print("start");
  }

  void _stop() {
    print("stop");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                "Recording: ${widget.project.tournament} - ${widget.project.home} vs. ${widget.project.guest}")),
        body: SafeArea(
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _start,
                      child: Text("Start"),
                    )),
                Spacer(flex: 1),
                Flexible(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: _stop,
                      child: Text("Stop"),
                    ))
              ],
            ),
          ),
        ));
  }
}
