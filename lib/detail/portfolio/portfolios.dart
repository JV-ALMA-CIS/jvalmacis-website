import '../agribusiness/agribusiness_content.dart';
import '../construction/construction_projects.dart';

/// Every unit portfolio whose projects have their own pages.
const portfolios = <Portfolio>[constructionPortfolio, agribusinessPortfolio];

/// The portfolio and project whose page lives at [route], if any.
({Portfolio portfolio, PortfolioProject project})? portfolioProjectForRoute(String? route) {
  for (final portfolio in portfolios) {
    if (portfolio.projectAt(route) case final project?) {
      return (portfolio: portfolio, project: project);
    }
  }
  return null;
}
