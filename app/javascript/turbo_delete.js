document.addEventListener('turbo:load', () => {
  document.querySelectorAll('a[data-turbo-method]').forEach(link => {
    link.addEventListener('click', function (event) {
      event.preventDefault();

      const method = link.dataset.turboMethod.toUpperCase();
      const form = document.createElement('form');
      form.method = 'POST';
      form.action = link.href;

      const methodInput = document.createElement('input');
      methodInput.type = 'hidden';
      methodInput.name = '_method';
      methodInput.value = method;
      form.appendChild(methodInput);

      const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content;
      if (csrfToken) {
        const csrfInput = document.createElement('input');
        csrfInput.type = 'hidden';
        csrfInput.name = 'authenticity_token';
        csrfInput.value = csrfToken;
        form.appendChild(csrfInput);
      }

      document.body.appendChild(form);
      form.submit();
    });
  });
});
