
import 'package:carton_todo_app/app/constants/app_dimentions.dart';
import 'package:flutter/material.dart';

class TodoDetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;
  final bool smallText;

  const TodoDetailRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
    this.smallText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon, 
          size: smallText ? AppDimensions.iconS : AppDimensions.iconM, 
          color: Colors.grey[700]
        ),
        SizedBox(width: AppDimensions.spacingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: smallText ? AppDimensions.fontXS : AppDimensions.fontS,
                ),
              ),
              SizedBox(height: AppDimensions.spacingXS / 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: smallText ? AppDimensions.fontS : AppDimensions.fontM,
                  color: valueColor,
                ),
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ],
    );
  }
}