FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
        zip \
        unzip \
        git \
        curl \
        libpng-dev \
        libjpeg-dev \
        libwebp-dev \
        libicu-dev \
        zlib1g-dev \
        libzip-dev \
        && docker-php-ext-install pdo pdo_mysql mysqli \
        && docker-php-ext-install pcntl \
        && docker-php-ext-install opcache \
        && docker-php-ext-install gd \
        && docker-php-ext-install mbstring \
        && docker-php-ext-configure intl \
        && docker-php-ext-install intl \
        && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy composer.json and composer.lock
COPY composer*.json ./

# Install dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Copy remaining files
COPY . .

# Expose port 9000
EXPOSE 9000

# Define default command
CMD ["php-fpm"]