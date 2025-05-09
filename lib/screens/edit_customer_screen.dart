import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/customer.dart';
import '../providers/customer_provider.dart';

class EditCustomerScreen extends ConsumerStatefulWidget {
  final Customer customer;

  EditCustomerScreen({required this.customer});

  @override
  _EditCustomerScreenState createState() => _EditCustomerScreenState();
}

class _EditCustomerScreenState extends ConsumerState<EditCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _weightController;
  late TextEditingController _feesController;
  late String _gender;
  late String _trainingType;
  late DateTime _startDate;
  late DateTime _endDate;
  late DateTime _dateOfBirth;
  late String _paymentStatus;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.customer.name);
    _phoneController = TextEditingController(text: widget.customer.phoneNumber);
    _weightController =
        TextEditingController(text: widget.customer.weight.toString());
    _feesController =
        TextEditingController(text: widget.customer.fees.toString());
    _gender = widget.customer.gender;
    _trainingType = widget.customer.trainingType;
    _startDate = widget.customer.startDate;
    _endDate = widget.customer.endDate;
    _dateOfBirth = widget.customer.dateOfBirth;
    _paymentStatus = widget.customer.paymentStatus;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _weightController.dispose();
    _feesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final updatedCustomer = Customer(
        id: widget.customer.id,
        name: _nameController.text,
        dateOfBirth: _dateOfBirth,
        phoneNumber: _phoneController.text,
        gender: _gender,
        weight: double.parse(_weightController.text),
        trainingType: _trainingType,
        startDate: _startDate,
        endDate: _endDate,
        fees: double.parse(_feesController.text),
        paymentStatus: _paymentStatus,
        planId: widget.customer.planId,
      );
      await ref.read(firebaseServiceProvider).updateCustomer(updatedCustomer);
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Color(0xFF2C3E50),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text(
              'Member Updated Successfully!',
              style: GoogleFonts.montserrat(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: GoogleFonts.poppins(
                color: Color(0xFF8E2DE2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2C3E50),
              Color(0xFF1A1A2E),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildCustomAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Personal Information'),
                        SizedBox(height: 16),
                        _buildTextField(_nameController, 'Name', Icons.person),
                        SizedBox(height: 16),
                        _buildTextField(
                            _phoneController, 'Phone Number', Icons.phone,
                            keyboardType: TextInputType.phone),
                        SizedBox(height: 16),
                        _buildTextField(_weightController, 'Weight (kg)',
                            Icons.fitness_center,
                            keyboardType: TextInputType.number),
                        SizedBox(height: 16),
                        _buildDatePicker('Date of Birth', _dateOfBirth,
                            (date) => setState(() => _dateOfBirth = date)),
                        SizedBox(height: 16),
                        _buildDropdown('Gender', ['Male', 'Female'], _gender,
                            (value) => setState(() => _gender = value!)),
                        SizedBox(height: 24),
                        _buildSectionTitle('Membership Details'),
                        SizedBox(height: 16),
                        _buildTextField(
                            _feesController, 'Fees', Icons.attach_money,
                            keyboardType: TextInputType.number),
                        SizedBox(height: 16),
                        _buildDropdown(
                            'Training Type',
                            ['Self', 'Personal'],
                            _trainingType,
                            (value) => setState(() => _trainingType = value!)),
                        SizedBox(height: 16),
                        _buildDropdown(
                            'Payment Status',
                            ['Paid', 'Pending'],
                            _paymentStatus,
                            (value) => setState(() => _paymentStatus = value!)),
                        SizedBox(height: 16),
                        _buildDatePicker('Start Date', _startDate,
                            (date) => setState(() => _startDate = date)),
                        SizedBox(height: 16),
                        _buildDatePicker('End Date', _endDate,
                            (date) => setState(() => _endDate = date)),
                        SizedBox(height: 32),
                        _isSubmitting
                            ? Center(
                                child: CircularProgressIndicator(
                                    color: Color(0xFF8E2DE2)))
                            : ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF8E2DE2),
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  'Update Member',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF8E2DE2),
            Color(0xFF4A00E0),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 8),
          Text(
            'Edit Member',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8E2DE2)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Color(0xFF8E2DE2)),
        ),
      ),
      dropdownColor: Color(0xFF2C3E50),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker(String label, DateTime selectedDate,
      void Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.dark(
                  primary: Color(0xFF8E2DE2),
                  onPrimary: Colors.white,
                  surface: Color(0xFF2C3E50),
                  onSurface: Colors.white,
                ),
                dialogBackgroundColor: Color(0xFF2C3E50),
              ),
              child: child!,
            );
          },
        );
        if (date != null) onDateSelected(date);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.white.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.white.withOpacity(0.1),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Color(0xFF8E2DE2)),
          ),
        ),
        child: Text(
          DateFormat.yMMMd().format(selectedDate),
          style: GoogleFonts.poppins(color: Colors.white),
        ),
      ),
    );
  }
}
