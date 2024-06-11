
import '../../../../core/utils/Resource.dart';
import '../../domain/repositories/welcome_repository.dart';
import '../api_client/welcome_api_client.dart';

class WelcomeRepositoryImpl extends WelcomeRepository {
  final WelcomeApiClient apiClient;
  WelcomeRepositoryImpl({required this.apiClient});
  @override
  Future<Resource> getIntroData(Map<String,dynamic>body,Map<String,dynamic>header) async {
    return await apiClient.getIntroData(body: body,header:header);
  }
}
