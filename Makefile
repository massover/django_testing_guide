GH_PAGES_SOURCES = docs dogs Makefile requirements.txt django_testing_guide
PROJECT_ROOT = /tmp/django_testing_guide

html:
	cd docs && $(MAKE) html

lint:
	flake8 django_testing_guide --exclude=django_testing_guide/settings.py
	flake8 django_testing_guide/settings.py --ignore=E501
	flake8 dogs --exclude=dogs/migrations
	flake8 docs/conf.py

open:
	open docs/_build/html/index.html

gh-pages:
	rm -rfv $(PROJECT_ROOT)
	git clone git@github.com:massover/django_testing_guide.git $(PROJECT_ROOT)
	cd $(PROJECT_ROOT); git checkout gh-pages
	cd $(PROJECT_ROOT); rm -rf ./*

	cd $(PROJECT_ROOT); git checkout master $(GH_PAGES_SOURCES)
	cd $(PROJECT_ROOT); git reset HEAD

	cd $(PROJECT_ROOT); virtualenv --python=$(which python3) venv
	cd $(PROJECT_ROOT); source venv/bin/activate; pip install -r requirements.txt

	cd $(PROJECT_ROOT); source venv/bin/activate; make html
	cd $(PROJECT_ROOT); mv -fv docs/_build/html/* ./
	cd $(PROJECT_ROOT); rm -rf $(GH_PAGES_SOURCES)
	cd $(PROJECT_ROOT); touch .nojekyll
	cd $(PROJECT_ROOT); git add -A
	cd $(PROJECT_ROOT) \
		&& git commit -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" \
		&& git push origin gh-pages \
		&& git checkout master