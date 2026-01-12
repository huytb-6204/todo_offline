import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? initial;

  const TaskFormScreen({super.key, this.initial});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtl;
  late final TextEditingController _descCtl;

  @override
  void initState() {
    super.initState();
    _titleCtl = TextEditingController(text: widget.initial?.title ?? '');
    _descCtl = TextEditingController(text: widget.initial?.description ?? '');
  }

  @override
  void dispose() {
    _titleCtl.dispose();
    _descCtl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final title = _titleCtl.text.trim();
    final desc = _descCtl.text.trim();
    final now = DateTime.now();

    final result = (widget.initial == null) ?
      Task(
        id: now.microsecondsSinceEpoch.toString(),
        title: title,
        description: desc,
        createdAt: now,
      ) : widget.initial!.copyWith(
        title: title,
        description: desc.isEmpty ? null : desc,  
      );  


      Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdited = widget.initial != null;


    return Scaffold(
      appBar: AppBar(
        title: Text(isEdited ? 'Edit Task' : 'New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: _titleCtl,
                decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title is required' : null,
              ),


              const SizedBox(height: 12.0),
              TextFormField(
                controller: _descCtl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Description is required' : null,
              ),


              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }

}