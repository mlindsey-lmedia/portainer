#!/bin/bash

# Wait for the database to be ready
until psql -h authentik-db -U authentik -d authentik -c '\l' > /dev/null 2>&1; do
    echo "Waiting for PostgreSQL to be ready..."
    sleep 2
done

# Create a superuser account
python3 /opt/authentik/authentik/manage.py createsuperuser --noinput --username admin --email admin@example.com --password 'adminpassword'

# Grant admin privileges (if needed)
python3 /opt/authentik/authentik/manage.py shell <<EOF
from authentik.core.models import User, Group
user = User.objects.get(username="admin")
admin_group, created = Group.objects.get_or_create(name="Admin")
user.groups.add(admin_group)
EOF
