import 'package:flutter/material.dart';
import 'package:live_analysis_tool/dto/project.dart';
import 'package:live_analysis_tool/services/project_service.dart';
import 'package:logger/logger.dart';
import 'package:supabase/supabase.dart';
import 'package:live_analysis_tool/components/auth_required_state.dart';
import 'package:live_analysis_tool/utils/constants.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends AuthRequiredState<DashboardPage> {
  final _projectService = ProjectService();
  final _log = Logger();
  bool _loading = true;

  _fetchProjects() async {
    var response = await _projectService.fetchProducts();
    final error = response.error;
    if (error != null && response.status != 406) {
      context.showErrorSnackBar(message: error.message);
    }
    final data = response.data as List;
    setState(() {
      _loading = false;
    });
    return data.map((p) => Project.fromJson(p)).toList();
  }

  /// Called when user taps `Update` button
  Future<void> _addProject() async {
    Navigator.of(context).pushNamed("/dashboard/addProject");
  }

  Future<void> _recordProject(Project project) async {
    Navigator.of(context).pushNamed("/dashboard/recording", arguments: project);
  }

  Future<void> _signOut() async {
    final response = await supabase.auth.signOut();
    final error = response.error;
    if (error != null) {
      context.showErrorSnackBar(message: error.message);
    }
  }

  @override
  void onAuthenticated(Session session) {
    final user = session.user;
    if (user != null) {
      _fetchProjects;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            FutureBuilder(
                future: _fetchProjects(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          Project project = snapshot.data[index];
                          return ListTile(
                            title: Text(project.tournament),
                            subtitle: Text(
                                '${project.round}: ${project.home} vs. ${project.guest}'),
                            onTap: () => _recordProject(project),
                          );
                        });
                  }
                }),
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              SizedBox(
                  height: 18,
                  child: Container(
                    color: Color.fromRGBO(255, 0, 0, 1),
                  )),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                    onPressed: _addProject,
                    child: Text(_loading ? 'Saving...' : 'Add Project')),
              ),
              const SizedBox(height: 18),
              SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                      onPressed: _signOut, child: const Text('Sign Out'))),
            ]),
          ],
        ),
      ),
    );
  }
}
