import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qrqrcode/scr/domain/models/scan_result.dart';
import 'package:qrqrcode/scr/domain/parser/qr_parser.dart';
import 'package:qrqrcode/scr/shared/utils/qr_utils.dart';
import 'package:qrqrcode/scr/ui/saved/controllers/saved_qr_controller.dart';
import 'package:qrqrcode/scr/ui/saved/pages/qr_code_infos_screen.dart';

class SavedQrCard extends StatefulWidget {
  final ScanResult scanResult;

  const SavedQrCard({
    super.key,
    required this.scanResult,
  });

  @override
  State<SavedQrCard> createState() => _SavedQrCardState();
}

class _SavedQrCardState extends State<SavedQrCard> {
  @override
  Widget build(BuildContext context) {
    final savedQrController = Provider.of<SavedQrController>(
      context,
      listen: false,
    );

    final String title = QRUtils.getTypeName_saveds(widget.scanResult.type);
    final String subtitle =
        QRParser.getSubtitle(widget.scanResult.type, widget.scanResult.rawValue);
    final String formattedDate =
        DateFormat('HH:mm, MMM d').format(widget.scanResult.scanTime);
    final Icon qrTypeIcon = QRUtils.getIconType(
      widget.scanResult.type,
      size: 24,
      color: Colors.white,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF151515),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 290), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QRcodeInfos(result: widget.scanResult),
                  ),
                );
              });
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: qrTypeIcon),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Color(0xFFBCBDBC),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          await savedQrController.removeQrCode(widget.scanResult.id);
                          
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removido dos Favoritos.'),
                                backgroundColor: Colors.red,
                                duration: Duration(milliseconds: 1400),
                              ),
                            );
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        splashColor: Colors.red.withOpacity(0.3),
                        highlightColor: Colors.transparent,
                        child: const Padding(
                          padding: EdgeInsets.all(4.0),
                          child: Icon(
                            Iconsax.heart5,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Color(0xFFBCBDBC),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}