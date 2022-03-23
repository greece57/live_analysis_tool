import 'package:live_analysis_tool/dto/project.dart';
import 'package:postgrest/postgrest.dart';
import 'package:live_analysis_tool/utils/constants.dart';

class ProjectService {
  Future<PostgrestResponse> fetchProducts() async {
    return await supabase
        .from("Projects")
        .select("*")
        .eq('user_id', supabase.auth.currentUser?.id)
        .execute();
  }

  Future<PostgrestResponse> addProject(Project project) async {
    final user = supabase.auth.currentUser;
    project.updatedAt = DateTime.now();
    return await supabase
        .from('Projects')
        .upsert(project.toJson(user))
        .execute();
  }
}
