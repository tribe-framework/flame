FROM php:8.4-fpm

# Install all system dependencies and packages
RUN apt-get update && apt-get install -y \
    vim \
    zip \
    unzip \
    p7zip-full \
    curl \
    s3cmd \
    poppler-utils \
    python3-pip \
    imagemagick \
    libmagickwand-dev \
    ffmpeg \
    net-tools \
    nginx \
    git \
    pdftk \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libwebp-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# Install ImageMagick PHP extension via PECL
RUN pecl install imagick \
    && docker-php-ext-enable imagick

# Install PHP extensions (using docker-php-ext-install for compatibility)
RUN docker-php-ext-install \
    pdo_mysql \
    mysqli \
    exif \
    pcntl \
    bcmath \
    zip \
    opcache

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy custom PHP configuration
COPY ./php.ini /usr/local/etc/php/php.ini

# Create user for php processes
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Change ownership of our applications
RUN chown -R www:www /var/www/html

# Change current user to www
USER www

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]