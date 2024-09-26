function transform(line) {
  var record;

  // Attempt to parse the JSON record
  try {
    record = JSON.parse(line);
  } catch (e) {
    return null;  // Filter out invalid records
  }

  // Validate appointment date format (YYYY-MM-DD)
  var datePattern = /^\d{4}-\d{2}-\d{2}$/;
  if (!datePattern.test(record.appointment_date)) {
    return null;  // Filter out invalid records with bad date format
  }

  // Validate the status
  var validStatuses = ["Booked", "Canceled", "Postponed"];
  if (validStatuses.indexOf(record.status) === -1) {
    return null;  // Filter out records with invalid status
  }

  // Validate feedback rating if it exists
  if (record.feedback && (record.feedback.rating < 1 || record.feedback.rating > 5)) {
    return null;  // Filter out records with invalid feedback rating
  }

  // Anonymize first_name and last_name
  record.first_name = anonymize(record.first_name);
  record.last_name = anonymize(record.last_name);

  // Return the valid, anonymized record
  return JSON.stringify(record);
}

// Anonymization function: converts a name to a hashed string
function anonymize(name) {
  var hash = 0;
  for (var i = 0; i < name.length; i++) {
    var char = name.charCodeAt(i);
    hash = ((hash << 5) - hash) + char;
    hash = hash & hash;  // Convert to 32-bit integer
  }
  return 'anon_' + Math.abs(hash).toString();  // Return anonymized string
}