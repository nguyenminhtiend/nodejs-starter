const { Schema, model } = require('mongoose');

const Department = model(
  'Department',
  Schema(
    {
      name: {
        type: String,
        required: true,
        trim: true,
        unique: true
      }
    },
    {
      timestamps: true
    }
  )
);

module.exports = Department;
