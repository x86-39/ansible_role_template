#!/bin/bash

if [ -z "$1" ]; then
    echo "Enter role name: "
    read NEW_ROLE_NAME
else
    NEW_ROLE_NAME=$1
fi

if [ -z "$2" ]; then
    if [ -z "$GITHUB_USER" ]; then
        echo "Enter github user: "
        read GITHUB_USER
    fi
else
    GITHUB_USER="$2"
fi

if [ -z "$3" ]; then
    if [ -z "$GALAXY_NAMESPACE" ]; then
        echo "Enter Ansble Galaxy namespace: "
        read GALAXY_NAMESPACE
    fi
else
    GALAXY_NAMESPACE="$3"
fi

if [ "$ROLE_IN_COLLECTION" != "true" ]; then # So I can skip this when using the template for a role in a collection
    if [ -z "$GALAXY_API_KEY" ]; then
        echo "Enter galaxy api key: "
        read GALAXY_API_KEY
    fi
fi

find defaults handlers meta molecule tasks vars LICENSE README.md run-localhost.yml\
    -type f -exec \
    sed -i -e "s/x86_39/${GALAXY_NAMESPACE}/g" \
    -e "s/x86-39/${GITHUB_USER}/g" \
    -e "s/template/${NEW_ROLE_NAME}/g" {} + # Do not run this more than once

if [ "$ROLE_IN_COLLECTION" != "true" && "$ROLE_IN_PROJECT" != "true" ]; then
    # Assumes repo is named ansible_role_${NEW_ROLE_NAME}
    gh secret set GALAXY_API_KEY -R ${GITHUB_USER}/ansible_role_${NEW_ROLE_NAME} -a actions -b ${GALAXY_API_KEY}
    mv ansible_role_template.code-workspace ansible_role_${NEW_ROLE_NAME}.code-workspace
else
    if [ "$ROLE_IN_COLLECTION" == "true" ]; then
        rm -r ./.github ./.gitlab-ci.yml ansible_role_template.code-workspace .gitignore LICENSE .pre-commit-config.yaml .ansible-lint
        sed -i "s/\[\!\[Molecule Test\].*//g" README.md

    elif [ "$ROLE_IN_PROJECT" == "true" ]; then
        rm -r ./.github ./.gitlab-ci.yml ansible_role_template.code-workspace .gitignore LICENSE .pre-commit-config.yaml .ansible-lint
    fi
fi

# Remove this section from README.md
sed -i "/Role Structure/Q" README.md


rm ./replace.sh
