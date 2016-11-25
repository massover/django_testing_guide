GH_PAGES_SOURCES = docs dogs Makefile .nojekyll

html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs
	flake8 docs/conf.py

gh-pages:
    git checkout gh-pages
    rm -rf ./*
    git checkout master $(GH_PAGES_SOURCES)
    git reset HEAD
    make html
    mv -fv docs/_build/html/* ./
    rm -rf $(GH_PAGES_SOURCES)
    git add -A
    git ci -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" \
        && git push origin gh-pages \
        && git checkout master