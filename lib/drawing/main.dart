import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<DrawingPoint?> points = [];
  Color selectedColor = Colors.black;
  double brushSize = 5.0;
  bool isEraser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Drawing App"),
        actions: [
          IconButton(
            icon: Icon(Icons.color_lens),
            onPressed: _pickColor,
          ),
          IconButton(
            icon: Icon(Icons.brush),
            onPressed: () {
              setState(() {
                isEraser = false;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.cleaning_services),
            onPressed: () {
              setState(() {
                isEraser = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.undo),
            onPressed: () {
              setState(() {
                if (points.isNotEmpty) points.removeLast();
              });
            },
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            points.add(DrawingPoint(details.localPosition,
                isEraser ? Colors.white : selectedColor, brushSize));
          });
        },
        onPanUpdate: (details) {
          setState(() {
            points.add(DrawingPoint(details.localPosition,
                isEraser ? Colors.white : selectedColor, brushSize));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: CustomPaint(
          painter: DrawingPainter(points),
          size: Size.infinite,
        ),
      ),
      bottomNavigationBar: Slider(
        value: brushSize,
        min: 1.0,
        max: 20.0,
        onChanged: (value) {
          setState(() {
            brushSize = value;
          });
        },
      ),
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Pick a color"),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> points;
  DrawingPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        Paint paint = Paint()
          ..color = points[i]!.color
          ..strokeCap = StrokeCap.round
          ..strokeWidth = points[i]!.size;
        canvas.drawLine(points[i]!.offset, points[i + 1]!.offset, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Color color;
  double size;
  DrawingPoint(this.offset, this.color, this.size);
}
