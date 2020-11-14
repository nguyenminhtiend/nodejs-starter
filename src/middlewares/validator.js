const Ajv = require('ajv');
const { AppError } = require('../utils');

const ajvOptionCore = { allErrors: true, $data: true };

const ajv = new Ajv(ajvOptionCore);
const ajvCoerceTypes = new Ajv({ ...ajvOptionCore, coerceTypes: true });
require('ajv-keywords')(ajv);
require('ajv-keywords')(ajvCoerceTypes);

const parseError = (errors) => errors.map((e) => ({
  message: `${e.dataPath} ${e.message}`,
}));

const validateSchema = (schema, data) => {
  const _ajv = schema.coerceTypes ? ajvCoerceTypes : ajv;
  const validate = _ajv.compile({
    ...schema,
    additionalProperties: schema.additionalProperties || false,
  });
  const valid = validate(data);
  if (!valid) {
    const errors = parseError(validate.errors);
    throw new AppError('One or more input are invalid!', 400, errors);
  }
};

module.exports = (schema) => (req, res, next) => {
  Object.keys(schema).forEach((key) => {
    validateSchema(schema[key], req[key]);
  });
  next();
};
