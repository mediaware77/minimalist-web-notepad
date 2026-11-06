FROM php:8.4-apache@sha256:884f64b47174de2c0e813270fe7b24a18605729fcebe201302d98c38805530d0

RUN a2enmod rewrite headers \
    && printf '<Directory /var/www/html>\n    AllowOverride All\n    Require all granted\n</Directory>\nServerTokens Prod\nServerSignature Off\n' > /etc/apache2/conf-available/notepad.conf \
    && a2enconf notepad \
    && mkdir -p /var/lib/notepad \
    && chown www-data:www-data /var/lib/notepad

COPY index.php .htaccess favicon.ico favicon.svg /var/www/html/
ENV NOTEPAD_DATA_DIR=/var/lib/notepad
VOLUME /var/lib/notepad
EXPOSE 80
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD php -r '$s = @get_headers("http://127.0.0.1/"); exit($s && str_contains($s[0], "302") ? 0 : 1);'
