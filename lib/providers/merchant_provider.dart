import 'package:flutter_riverpod/flutter_riverpod.dart';

final merchantProvider = StateNotifierProvider<MerchantNotifier, MerchantState>(
  (ref) => MerchantNotifier(),
);

class MerchantState {
  final String? marketName;
  final int? marketId;
  final String? marketAddress;

  const MerchantState({this.marketName, this.marketId, this.marketAddress});
}

class MerchantNotifier extends StateNotifier<MerchantState> {
  MerchantNotifier() : super(const MerchantState());

  void update({required String marketName, required int marketId, required String marketAddress}) {
    state = MerchantState(marketName: marketName, marketId: marketId, marketAddress: marketAddress);
  }
}