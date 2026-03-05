import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/dashboard_repository.dart';
import '../../domain/entities/dashboard_entities.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({
    DashboardRepository? repository,
  })  : _repository = repository ?? MockDashboardRepository(),
        super(const DashboardState.initial());

  final DashboardRepository _repository;

  Future<void> loadMockData() async {
    emit(state.copyWith(status: DashboardStatus.loading));
    try {
      final data = await _repository.fetchDashboard();
      emit(
        state.copyWith(
          status: DashboardStatus.success,
          stats: data.stats,
          recentOrders: data.recentOrders,
          walletOverview: data.walletOverview,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DashboardStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

