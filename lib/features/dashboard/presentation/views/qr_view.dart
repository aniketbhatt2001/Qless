import 'dart:developer';

import 'package:canteen_mangement/core/errors/app_error_handler.dart';
import 'package:canteen_mangement/core/utils/custom_snackbar.dart';
import 'package:canteen_mangement/features/auth/presentation/controllers/auth_controller.dart';
import 'package:canteen_mangement/features/dashboard/presentation/views/dashboard_view_original_backup.dart';
import 'package:canteen_mangement/features/order/domain/usecases/mark_order_ready_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerView extends StatefulWidget {
  final String? orderId;

  const QrScannerView({super.key, this.orderId});

  @override
  State<QrScannerView> createState() => _QrScannerViewState();
}

class _QrScannerViewState extends State<QrScannerView>
    with SingleTickerProviderStateMixin {
  final MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool scanningLocked = false;
  final _markOrderReady = Get.find<MarkOrderReadyUseCase>();

  late AnimationController scanLineController;

  @override
  void initState() {
    super.initState();

    scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    cameraController.dispose();
    scanLineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double scanSize = 260;

    final user = Get.find<AuthController>().user.value;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// CAMERA
          MobileScanner(
            controller: cameraController,
            onDetect: (BarcodeCapture capture) async {
              if (scanningLocked) return;

              final barcode = capture.barcodes.firstOrNull;
              if (barcode == null) return;

              final code = barcode.rawValue;
              if (code == null) return;

              scanningLocked = true;

              final userId = code.split('-').lastOrNull;
                final orderId = code.split('-').firstOrNull;
              final id = user?.id;
log("code... ${code}");
              if (userId == id) {
                await _showSuccess(orderId);
              } else {
                await _showFailure();

                scanningLocked = false;
                cameraController.start();
              }
            },
          ),

          /// DARK OVERLAY
          Positioned.fill(
            child: CustomPaint(painter: _ScannerOverlayPainter(scanSize)),
          ),

          /// HEADER
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            child: Column(
              children: [
                const Text(
                  "Scan Your Canteen QR",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  "Verify your identity to access your order",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 20),

                /// USER CARD
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.black),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "User ID: ${user?.id}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// SCANNER WINDOW
          Center(
            child: SizedBox(
              width: scanSize,
              height: scanSize,
              child: Stack(
                children: [
                  /// CORNERS
                  _buildCorner(Alignment.topLeft),
                  _buildCorner(Alignment.topRight),
                  _buildCorner(Alignment.bottomLeft),
                  _buildCorner(Alignment.bottomRight),

                  /// SCAN LINE
                  AnimatedBuilder(
                    animation: scanLineController,
                    builder: (context, child) {
                      return Positioned(
                        top: scanSize * scanLineController.value,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 3,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                Colors.greenAccent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          /// INSTRUCTION
          const Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Text(
              "Align QR code inside the frame",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
          ),

          /// FLASH BUTTON
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                iconSize: 34,
                color: Colors.white,
                icon: const Icon(Icons.flash_on),
                onPressed: () => cameraController.toggleTorch(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top:
                alignment == Alignment.topLeft ||
                        alignment == Alignment.topRight
                    ? const BorderSide(color: Colors.greenAccent, width: 4)
                    : BorderSide.none,
            bottom:
                alignment == Alignment.bottomLeft ||
                        alignment == Alignment.bottomRight
                    ? const BorderSide(color: Colors.greenAccent, width: 4)
                    : BorderSide.none,
            left:
                alignment == Alignment.topLeft ||
                        alignment == Alignment.bottomLeft
                    ? const BorderSide(color: Colors.greenAccent, width: 4)
                    : BorderSide.none,
            right:
                alignment == Alignment.topRight ||
                        alignment == Alignment.bottomRight
                    ? const BorderSide(color: Colors.greenAccent, width: 4)
                    : BorderSide.none,
          ),
        ),
      ),
    );
  }

  Future<void> _showSuccess(String? orderId) async {
    HapticFeedback.mediumImpact();

 
    log("orderId.........${orderId}");
    if (orderId != null) {
      try {
        await _markOrderReady(orderId);
      } catch (e) {
        CustomSnackbar.show(
          title: "Error",
          message: AppErrorHandler.getMessage(e),
          isError: true,
        );
      }
    }

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) =>  _ResultDialog(onPressed: () {
             Get.offAll( DashboardView(index: 3));
          },
            icon: Icons.check_circle,
            color: Colors.green,
            title: "Verification Successful",
            message: "QR code matches your account",
          ),
    );
  }

  Future<void> _showFailure() async {
    HapticFeedback.heavyImpact();

    await showDialog(
      context: context,
      builder:
          (context) =>  _ResultDialog(onPressed: () {
            Get.back();
          },
            icon: Icons.cancel,
            color: Colors.red,
            title: "Verification Failed",
            message: "This QR code does not belong to your account",
          ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String message;
  final Function ()? onPressed;

  const _ResultDialog({
    required this.icon,
    required this.color,
    required this.title,
    required this.message,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 60, color: color),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 18),
            ElevatedButton(
     onPressed: onPressed,
              child: const Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final double scanSize;

  _ScannerOverlayPainter(this.scanSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(.6);

    final center = Offset(size.width / 2, size.height / 2);

    final rect = Rect.fromCenter(
      center: center,
      width: scanSize,
      height: scanSize,
    );

    final background =
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutout =
        Path()
          ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)));

    final overlay = Path.combine(PathOperation.difference, background, cutout);

    canvas.drawPath(overlay, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
