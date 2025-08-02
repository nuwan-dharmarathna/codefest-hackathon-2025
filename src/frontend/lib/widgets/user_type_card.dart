import 'package:flutter/material.dart';
import 'package:frontend/models/user_model.dart';

class UserTypeCard extends StatelessWidget {
  final UserRole type;
  final bool isSelected;
  final VoidCallback onTap;
  final String description;

  const UserTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.11,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white60
              : Colors.white54.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                type == UserRole.buyer
                    ? "assets/icons/buyer.png"
                    : "assets/icons/seller.png",
                width: MediaQuery.of(context).size.width * 0.15,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      type == UserRole.buyer ? "Buyer" : "Seller",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
