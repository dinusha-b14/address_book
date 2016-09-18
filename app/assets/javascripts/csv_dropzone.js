Dropzone.options.csvDropZone = {
  paramName: 'batch[file]',
  maxFilesize: 5,
  acceptedFiles: 'text/csv,.csv',
  uploadMultiple: false,
  init: function() {
    this.on('success', function(file, response) {
      window.location.replace(response.resource_url);
    });
  }
};
