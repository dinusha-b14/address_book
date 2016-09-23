Dropzone.options.csvDropZone = {
  paramName: 'batch[file]',
  maxFilesize: 5,
  acceptedFiles: 'text/csv,.csv',
  uploadMultiple: false,
  init: function() {
    this.on('addedfile', function(file) {
      $('#file-upload-errors').hide();
    });
    this.on('success', function(file, response) {
      window.location.replace(response.resource_url);
    });
    this.on('error', function(file, errorMessage) {
      var displayMessage = "<p>The following error was found: </p>\n<p>" + errorMessage.file[0] + "</p>";
      $('#file-upload-errors').html(displayMessage);
      $('#file-upload-errors').show();
    });
  }
};
