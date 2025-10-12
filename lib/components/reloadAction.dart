import 'package:flutter/material.dart';
import 'package:projet_ia/services/ia_service.dart';
import 'package:provider/provider.dart';
import 'package:projet_ia/providers/user_id_provider.dart';

class ReloadAction extends StatefulWidget {
  final Function(String) onReloadAction;
  const ReloadAction({Key? key, required this.onReloadAction})
    : super(key: key);

  @override
  State<ReloadAction> createState() => _ReloadActionState();
}

class _ReloadActionState extends State<ReloadAction> {
  final IAService iaService = IAService();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final String uniqueId = context.read<UserIdProvider>().userId;
          String response = await iaService.reload(uniqueId);
          print(response);
          widget.onReloadAction(response);
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: const Text(
          "Vérifier votre connexion internet et réactualisé ",
          style: TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
