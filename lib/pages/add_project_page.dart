import 'package:flutter/material.dart';
import 'package:live_analysis_tool/dto/project.dart';
import 'package:live_analysis_tool/services/project_service.dart';
import 'package:live_analysis_tool/components/auth_required_state.dart';
import 'package:live_analysis_tool/utils/constants.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({Key? key}) : super(key: key);

  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends AuthRequiredState<AddProjectPage> {
  final _projectService = ProjectService();

  final _tournamentController = TextEditingController();
  final _roundController = TextEditingController();
  final _homeController = TextEditingController();
  final _guestController = TextEditingController();

  bool _isAddProjectButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _updateAddProjectButton();
    _tournamentController.addListener(_updateAddProjectButton);
    _roundController.addListener(_updateAddProjectButton);
    _homeController.addListener(_updateAddProjectButton);
    _guestController.addListener(_updateAddProjectButton);
  }

  void _updateAddProjectButton() {
    setState(() {
      _isAddProjectButtonEnabled = _tournamentController.text.isNotEmpty &&
          _roundController.text.isNotEmpty &&
          _homeController.text.isNotEmpty &&
          _guestController.text.isNotEmpty;
    });
  }

  /// Called when user taps `Update` button
  void _addProject() async {
    final tournament = _tournamentController.text;
    final round = _roundController.text;
    final home = _homeController.text;
    final guest = _guestController.text;

    final project = Project.draft(tournament, round, home, guest);
    final response = await _projectService.addProject(project);

    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    } else {
      context.showSnackBar(message: 'Successfully added Project!');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Dashboard')),
        body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
            children: [
              TextFormField(
                controller: _tournamentController,
                decoration: InputDecoration(
                  labelText: 'Turnier',
                  errorText: (_tournamentController.text.isEmpty
                      ? "Kein Inhalt"
                      : null),
                ),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _roundController,
                decoration: InputDecoration(
                    labelText: 'Runde',
                    errorText:
                        (_roundController.text.isEmpty ? "Kein Inhalt" : null)),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _homeController,
                decoration: InputDecoration(
                    labelText: 'Heim-Team',
                    errorText:
                        (_homeController.text.isEmpty ? "Kein Inhalt" : null)),
              ),
              const SizedBox(height: 18),
              TextFormField(
                controller: _guestController,
                decoration: InputDecoration(
                    labelText: 'Gast-Team',
                    errorText:
                        (_guestController.text.isEmpty ? "Kein Inhalt" : null)),
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _isAddProjectButtonEnabled ? _addProject : null,
                child: const Text("Add Project"),
              )
            ]));
  }
}
