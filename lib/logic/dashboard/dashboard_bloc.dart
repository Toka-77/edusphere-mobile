import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import '../../data/services/dashboard_service.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardService dashboardService;

  DashboardBloc({required this.dashboardService}) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final data = await dashboardService.loadDashboard(event.studentId);
      emit(DashboardLoaded(data));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
